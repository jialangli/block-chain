<script setup>
import { ref, onMounted, computed } from "vue";
import Web3 from 'web3'; // 将web3的首字母大写
import mtcJSON from '../MYtoken/artifacts/Mytoken.json';
const geerliWS = "wss://goerli.infura.io/ws/v3/e4f7889009c9245eeaad1d93ce9d059bb";
const web3Instance = new Web3(Web3.givenProvider || geerliWS); // 使用不同的变量名来存储Web3实例
const mtcContract = new web3Instance.eth.Contract(
  mtcJSON.abi,
  "0xcD6a42782d230D7c13A74ddec5dD140e55499Df9"
);

const currentAccount = ref("");
const name = ref("");
const symbol = ref("");
const totalSupply = ref("");
const balanceOf = ref(0);

// 转账信息
const toAddress = ref("");
const amount = ref("");

const getCoinInfo = async () => {
  const account = await web3Instance.eth.requestAccounts();
  console.log(account);
  currentAccount.value = account[0];

  name.value = await mtcContract.methods.name().call(); //用call不消耗gas
  symbol.value = await mtcContract.methods.symbol().call();
  totalSupply.value = await mtcContract.methods.totalSupply().call();
  balanceOf.value = await mtcContract.methods.balanceOf(currentAccount.value).call();
};
const ts = computed(() => {
  return web3Instance.utils.fromWei(totalSupply.value, 'ether');
});
const bo = computed(() => {
  return web3Instance.utils.fromWei(balanceOf.value, 'ether');
});
onMounted(() => {
  getCoinInfo();
});

const send = () => {
  const weiAmount = web3Instance.utils.toWei(amount.value, 'ether');
  mtcContract.methods.transfer(toAddress.value, weiAmount).send({
    from: currentAccount.value,
  })
  .on('receipt', (res) => {
    console.log("交易成功！");
    console.log(res);
  });
};
</script>

<template>
  <div>LJLC基本信息:{{ currentAccount }}</div>
  <hr/>
  <p>代币名称:{{ name }}</p>
  <p>代币标识:{{ symbol }}</p>
  <p>发行量:{{ ts }}</p>
  <p>持有数量:{{ bo }}</p>
  <h1>转账操作:</h1>
  <hr/>
  <p>转入地址：<input type="text" v-model="toAddress" class="address" /></p>
  <p>转出金额：<input type="text" v-model="amount"/>LJLC</p>
  <button @click="send">开始转账</button>
</template>

<style lang="less">
.address {
  width: 500px;
}
</style>
<script setup>

const year = new Date().getFullYear();

</script>

<template>

  <footer class="footer">
    <p>
      Hangman game made by <a href="https://lucieblr.com/">Lucie BLR</a>
      | <a href="https://github.com/lucie-blr/hangman">Github</a>
    </p>
  </footer>

</template>

<style scoped lang="scss">

.footer {
  text-align: center;
  padding: 20px;
  background-color: #f8f8f8;
  border-top: 1px solid #e7e7e7;
  bottom: 0;
  position: fixed;
  width: 100%;

  p {
    margin: 5px 0;
    color: #555;
    font-size: 14px;
  }

  a {
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
}

</style>
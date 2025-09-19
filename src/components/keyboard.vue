<script setup>

const props = defineProps({
  letters: Array,
  word: String
});

</script>

<template>
<div class="keyboard-component">
  <div class="keyboard">
      <button
        v-for="key in 'AZERTYUIOPQSDFGHJKLMWXCVBN'"
        :key="key"
        :class="(letters.includes(key) ? (word.includes(key) ? 'right' : 'false') : '') + ' key'"
        :disabled="(letters.includes(key))"
        @click="$emit('update:letter', key)"
      >
        {{ key }}
      </button>
  </div>
</div>
</template>

<style scoped lang="scss">

.keyboard-component {
  display: flex;
  justify-content: center;
  margin-top: 20px;

  .keyboard {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    // max items in a row

    gap: 10px;

    .key {
      width: calc(100% * (1/10) - 10px - 1px);
      height: 40px;
      font-size: 16px;
      border: none;
      border-radius: 5px;
      background-color: #f0f0f0;
      cursor: pointer;
      transition: background-color 0.3s;

      &:disabled {
        cursor: not-allowed;
      }

      &:hover:not(:disabled) {
        background-color: #e0e0e0;
      }
    }

    .right {
      background-color: #bce6a0;
    }

    .false {
      background-color: #f5a3a3;
    }


    @media (max-width: 768px) {

      .key {
        height: 30px;
      }
    }

    @media (max-width: 480px) {
      .key {
        width: calc(100% * (1/6) - 1px);
        height: 25px;
      }
    }
  }
}

</style>
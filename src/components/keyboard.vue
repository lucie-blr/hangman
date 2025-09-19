<script setup>

const props = defineProps({
  letters: Array,
  word: String
});

</script>

<template>
<div class="keyboard-component">
  <div class="keyboard">
    <div class="row" v-for="row in ['AZERTYUIOP', 'QSDFGHJKLM', 'WXCVBN']" :key="row">
      <button
        v-for="key in row"
        :key="key"
        :class="(letters.includes(key) ? (word.includes(key) ? 'right' : 'false') : '') + ' key'"
        :disabled="(letters.includes(key))"
        @click="$emit('update:letter', key)"
      >
        {{ key }}
      </button>
    </div>
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
    flex-direction: column;
    gap: 10px;

    .row {
      display: flex;
      justify-content: center;
      gap: 5px;



      .key {
        width: 40px;
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
    }
  }
}

</style>
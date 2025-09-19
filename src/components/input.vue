<script setup>
import {ref, onMounted, watch, computed} from 'vue';

// get word from props
const props = defineProps({
  word: String,
  letters: Array
});

const emit = defineEmits(['update:guess'])

const inputs = ref([]);

const guess = ref('');

// valeur affichée dans chaque input en fonction de props.letters
const inputValues = computed(() =>
    props.word.split('').map((letter) =>
        props.letters.includes(letter) ? letter : ''
    )
);

const focusNextInput = (index) => {
  if (!inputs.value[index].value) {
    while (index > 0) {
      if (!inputs.value[index - 1].disabled) {
        inputs.value[index - 1].focus();
        break;
      }
      index--;
    }
  } else
  while (index < inputs.value.length - 1) {
    if (!inputs.value[index + 1].disabled) {
      inputs.value[index + 1].focus();
      break;
    }
    index++;
  }

  guess.value = inputs.value.map(input => input.value).join('').toUpperCase();
};

const emitGuess = () => {
  if (guess.value.length !== props.word.length) {

    // shake the input box
    inputs.value.forEach(input => {
      input.classList.add('shake');
      setTimeout(() => {
        input.classList.remove('shake');
      }, 500);
    });

    return;
  }

  emit('update:guess', guess.value);
};

onMounted(() => {
  inputs.value = inputs.value.slice(0, props.word.length);
});

watch(
    () => props.letters,
    () => {
      guess.value = inputValues.value.join('');
    },
    { deep: true }
);

</script>

<template>
<div class="input-component">
  <input
      v-for="(char, index) in inputValues"
      :key="index"
      maxlength="1"
      ref="inputs"
      :value="char"
      :disabled="char !== ''"
      @input="focusNextInput(index)"
  />
  <button @click="emitGuess">Submit</button>
</div>
</template>

<style lang="scss">

.input-component {
  display: flex;
  gap: 10px;
  align-items: center;
  justify-content: center;

  input {
    width: 30px;
    height: 33px;
    text-align: center;
    font-size: 20px;
    transition: color 0.3s, border-color 0.3s;
    border: 2px solid rgba(0, 0, 0, 0.32);

    &.shake {
      border-color: red;
      animation: shake 0.5s;
    }

    &.win {
      border-color: #a8ea7d;
      animation: winAnimation 0.2s ease-in-out;
    }

    &.lose {
      border-color: red;
      animation: shake 0.5s;
    }

    @keyframes shake {
      0% { transform: translate(1px, 1px) rotate(0deg); }
      10% { transform: translate(-1px, -2px) rotate(-1deg); }
      20% { transform: translate(-3px, 0px) rotate(1deg); }
      30% { transform: translate(3px, 2px) rotate(0deg); }
      40% { transform: translate(1px, -1px) rotate(1deg); }
      50% { transform: translate(-1px, 2px) rotate(-1deg); }
      60% { transform: translate(-3px, 1px) rotate(0deg); }
      70% { transform: translate(3px, 1px) rotate(-1deg); }
      80% { transform: translate(-1px, -1px) rotate(1deg); }
      90% { transform: translate(1px, 2px) rotate(0deg); }
      100% { transform: translate(1px, -2px) rotate(-1deg); }
    }

    @keyframes winAnimation {
      0% { transform: scale(1); }
      50% { transform: scale(1.1); }
      100% { transform: scale(1); }
    }
  }
}

</style>
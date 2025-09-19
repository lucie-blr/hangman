<script setup>
import {onMounted, ref} from 'vue';
import InputComponent from './components/input.vue';
import KeyboardComponent from './components/keyboard.vue';

const letters = ref([]);
const guess = ref('');
const word = ref('');
const tries = ref(0);
const maxTries = 6;

async function getWord() {
  // get a random word from assets/francais.txt
  word.value = '';

  const response = await fetch("/francais.txt");
  const text = await response.text();
  const mots = text.split(/\r?\n/).filter(Boolean);

  const randomIndex = Math.floor(Math.random() * mots.length);
  word.value = mots[randomIndex].toUpperCase();

  console.log(word.value);
};

const updateGuess = (newGuess) => {
  guess.value = newGuess;
  tries.value += 1;
  end();
};

const addLetter = (letter) => {
  if (!letters.value.includes(letter)) {
    letters.value.push(letter);
    if (!word.value.includes(letter)) {
      tries.value += 1;
      end();
    }
  }
};

const end = () => {
  // ajouter une classe "win" aux inputs
  const inputs = document.querySelectorAll('.Inputs input');
  if (guess.value === word.value) {
    inputs.forEach(input => {
      input.classList.add('win');
    });
  } else if (tries.value >= maxTries) {
    inputs.forEach(input => {
      input.classList.add('lose');
    });
  } else {
    return;
  }

  // désactiver les inputs
  inputs.forEach(input => {
    input.disabled = true;
  });

  // désactiver le clavier
  const keys = document.querySelectorAll('.keyboard-component button');
  keys.forEach(key => {
    key.disabled = true;
  });
};

onMounted(() => {
  getWord();
});


</script>

<template>

  <div id="app">
    <div class="Inputs">
      <h1>Jeu du Pendu</h1>
      <p v-if="tries > 0">Nombre d'essais : {{ tries }}</p>
      <p v-if="guess === word">Félicitations ! Vous avez trouvé le mot : {{ word }}</p>
      <p v-else-if="tries >= maxTries">Dommage ! Le mot était : {{ word }}</p>
      <InputComponent :word="word" :letters="letters" @update:guess="updateGuess"/>
      <KeyboardComponent :letters="letters" :word="word" @update:letter="addLetter"/>
    </div>
    <div class="Game">
      <img src="./assets/shrek.png" alt="Car"/>
    </div>
  </div>

</template>

<style scoped lang="scss">

#app {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 50px;
  height: 100vh;

  .Inputs {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
    width: 80vw;
  }

  .Game {
    width: calc(20vw - 50px);
    margin: 0;
    padding: 0;

    img {
      width: 100%;
      height: auto;
    }
  }

  @media screen and (max-width: 768px) {
    flex-direction: column;
    .Game {
      order: -1;
      width: 50vw;
    }
  }
}

</style>

<script setup lang="ts">
import { ref } from "vue";
import axios from "axios";

const pingResult = ref<string>("");
const loading = ref(false);

const dittoLoading = ref(false);
const dittoAbilities = ref<string[]>([]);
const dittoError = ref<string>("");

async function ping() {
  loading.value = true;
  try {
    const res = await fetch("/api/ping");
    pingResult.value = await res.text();
  } catch (err) {
    pingResult.value = `Error: ${String(err)}`;
  } finally {
    loading.value = false;
  }
}

async function fetchDitto() {
  dittoLoading.value = true;
  dittoAbilities.value = [];
  dittoError.value = "";
  try {
    const res = await axios.get("https://pokeapi.co/api/v2/pokemon/ditto");
    dittoAbilities.value = res.data.abilities.map(
      (a: { ability: { name: string } }) => a.ability.name
    );
  } catch (err) {
    dittoError.value = `Error: ${String(err)}`;
  } finally {
    dittoLoading.value = false;
  }
}
</script>

<template>
  <main>
    <h1>Express + Vue</h1>
    <p>A TypeScript app using npm workspaces.</p>
    <button :disabled="loading" @click="ping">
      {{ loading ? "Pinging…" : "Ping the server" }}
    </button>
    <p v-if="pingResult">
      Server replied: <strong>{{ pingResult }}</strong>
    </p>

    <hr />

    <button :disabled="dittoLoading" @click="fetchDitto">
      {{ dittoLoading ? "Loading…" : "Ditto" }}
    </button>
    <p v-if="dittoError">{{ dittoError }}</p>
    <ul v-if="dittoAbilities.length">
      <li v-for="ability in dittoAbilities" :key="ability">{{ ability }}</li>
    </ul>
  </main>
</template>

<style scoped>
main {
  font-family: system-ui, sans-serif;
  max-width: 480px;
  margin: 4rem auto;
  text-align: center;
}
button {
  padding: 0.5rem 1rem;
  font-size: 1rem;
  cursor: pointer;
}
hr {
  margin: 1.5rem 0;
  border: none;
  border-top: 1px solid #ccc;
}
ul {
  list-style: none;
  padding: 0;
  margin-top: 0.75rem;
}
li {
  font-size: 1rem;
  padding: 0.25rem 0;
}
</style>

·
<template>
  <div class="top-bar-container border-b flex-between">
    <div class="flex-center h-full">
      <div class="app-title-container cursor" @click="router.push('/')">
        <div class="logo flex-center">
          <LogoFull />
        </div>
      </div>
      <TopMenu></TopMenu>
    </div>
    <div class="flex-center avatar">
      <Avatar></Avatar>
    </div>
  </div>
</template>
<script setup lang="ts">
import TopMenu from './top-menu/index.vue'
import Avatar from './avatar/index.vue'
import { useRouter } from 'vue-router'
const router = useRouter()
</script>
<style lang="scss">
.top-bar-container {
  height: var(--app-header-height);
  box-sizing: border-box;
  padding: var(--app-header-padding);

  .app-title-container {
    margin-right: 45px;
  }

  .line {
    height: 2em;
  }
}
</style>

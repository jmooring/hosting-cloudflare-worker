---
title: Webhook
---

This currency exchange rate is refreshed every time the project is built—triggered either by a code commit to GitHub or a daily GitHub Action cron job that calls a Cloudflare webhook. Once the build is initiated by either event, the current rate is dynamically pulled directly from the Norges Bank API using Hugo's `resources.GetRemote` function.

Because `resources.GetRemote` fetches data at build time rather than request time, the exchange rate is embedded in the static HTML at the moment the project is built. Without a scheduled build, the displayed rate would only update when someone commits code to the repository—potentially leaving stale data for days. 

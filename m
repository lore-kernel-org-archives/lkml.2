Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ENNW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:22:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39429 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab2ENNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:22:57 -0400
MIME-Version: 1.0
Date: Mon, 14 May 2012 21:22:57 +0800
Message-ID: <CAJd=RBCy_njUJHez6iUHXbsv67mR41nj==aFn5fYhm_69h4=XA@mail.gmail.com>
Subject: [3/3] BFS 420: cleanup the default root domain
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BFS earns little with two default root domains defined.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Mon May 14 20:57:36 2012
@@ -322,12 +322,6 @@ static DEFINE_MUTEX(sched_hotcpu_mutex);
  */
 static DEFINE_MUTEX(sched_domains_mutex);

-/*
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
- */
-static struct root_domain def_root_domain;
-
 int __weak arch_sd_sibling_asym_packing(void)
 {
        return 0*SD_ASYM_PACKING;
--

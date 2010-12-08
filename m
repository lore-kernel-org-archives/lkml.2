Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab0LHFKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:10:22 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:34542 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0LHFKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:10:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GUj9S956vL0T9vbksXjbsnkRttOToRaKkSnUTym+KKvY2p/bLbeTiJ4/1l5nspGBJ9
         sL3Vk/Nn5Dbb0Zb4IFvd/71Gl6f5VTRUJ9r0BUl33MBWwr4Ucg6G/DNOAMe7a+tkTL4s
         OvLXliEKCw+NA471OosYnA0SpjONvresezvEc=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimer: fix a typo in comment
Date: Wed,  8 Dec 2010 14:09:51 +0900
Message-Id: <1291784991-5047-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/hrtimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 72206cf..66163df 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1774,7 +1774,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
 	}
 
 	/*
-	 * A NULL parameter means "inifinte"
+	 * A NULL parameter means "infinite"
 	 */
 	if (!expires) {
 		schedule();
-- 
1.7.3.3.398.g0b0cd.dirty


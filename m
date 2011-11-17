Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1KQORJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:17:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60609 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1KQORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:17:07 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH] Kernel: time: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 07:16:50 -0700
Message-Id: <1321539410-3982-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 73e416d..7084be0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -505,7 +505,7 @@ timespec_to_jiffies(const struct timespec *value)
 	unsigned long sec = value->tv_sec;
 	long nsec = value->tv_nsec + TICK_NSEC - 1;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		nsec = 0;
 	}
-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab2D0INJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:13:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63568 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2D0INB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:13:01 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 2/5] ntp: Fix a stale comment and a few stray newlines.
Date: Fri, 27 Apr 2012 10:12:41 +0200
Message-Id: <5f62cef3da3fa954d9f4f246053e15da1724e792.1335510125.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/ntp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f03fd83..d0a2183 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -473,8 +473,6 @@ int second_overflow(unsigned long secs)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
 
-
-
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
 
@@ -559,10 +557,10 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
 	time_status |= txc->status & ~STA_RONLY;
-
 }
+
 /*
- * Called with the xtime lock held, so we can access and modify
+ * Called with ntp_lock held, so we can access and modify
  * all the global NTP state:
  */
 static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)
-- 
1.7.2.5


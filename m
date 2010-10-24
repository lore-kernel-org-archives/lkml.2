Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0JXDvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 23:51:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52694 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab0JXDvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 23:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I6qfQ9IcSSFREJTm81pPZRafeG2epF3JvGECCEVk1F5F7IyOtaemyF5kAcsoqXpA1e
         PcukcPIfw/2KIlgsjqFsqc+q53QHuoVCadImk/JFJKyr0PIPdDx36HUiMtnbB9zXiXO6
         1m4UwXwbdcnsmByN5y0mHBzNKCIctJyUUWupw=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [PATCH] hrtimer: remove comment on curr_timer
Date: Sun, 24 Oct 2010 11:50:53 +0800
Message-Id: <1287892253-2587-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Now curr_timer doesn't resident in struct hrtimer_cpu_base anymore.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/hrtimer.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0c1b8..dd9954b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -158,7 +158,6 @@ struct hrtimer_clock_base {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @clock_base:		array of clock bases for this cpu
- * @curr_timer:		the timer which is executing a callback right now
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
-- 
1.7.0.4


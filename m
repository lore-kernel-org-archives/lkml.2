Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2D0IOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:14:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64908 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab2D0IND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:13:03 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 3/5] timekeeping: Fix a few minor newline issues.
Date: Fri, 27 Apr 2012 10:12:42 +0200
Message-Id: <06c2be99fe106eba4552002ebf0839db3a34b5ec.1335510125.git.richardcochran@gmail.com>
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
 kernel/time/timekeeping.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d66b213..6e46cac 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -240,7 +240,6 @@ void getnstimeofday(struct timespec *ts)
 
 	timespec_add_ns(ts, nsecs);
 }
-
 EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
@@ -357,8 +356,8 @@ void do_gettimeofday(struct timeval *tv)
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
-
 EXPORT_SYMBOL(do_gettimeofday);
+
 /**
  * do_settimeofday - Sets the time of day
  * @tv:		pointer to the timespec variable containing the new time
@@ -392,7 +391,6 @@ int do_settimeofday(const struct timespec *tv)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(do_settimeofday);
 
 
-- 
1.7.2.5


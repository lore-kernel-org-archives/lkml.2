Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2G0Stc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:49:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36219 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2G0Ssz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:48:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 3/5] time: Stray newline cleanups
Date: Fri, 27 Jul 2012 14:48:11 -0400
Message-Id: <1343414893-45779-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-2398-0000-0000-000008E66DEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted inconsistent newline usage between functions.
This patch cleans those up.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f045cc5..8d8636f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -239,7 +239,6 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
 
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -436,7 +435,6 @@ int do_settimeofday(const struct timespec *tv)
 }
 EXPORT_SYMBOL(do_settimeofday);
 
-
 /**
  * timekeeping_inject_offset - Adds or subtracts from the current time.
  * @tv:		pointer to the timespec variable containing the offset
@@ -550,7 +548,6 @@ void getrawmonotonic(struct timespec *ts)
 }
 EXPORT_SYMBOL(getrawmonotonic);
 
-
 /**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
@@ -683,7 +680,6 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 	update_sleep_time(timespec_add(tk->total_sleep_time, *delta));
 }
 
-
 /**
  * timekeeping_inject_sleeptime - Adds suspend interval to timeekeeping values
  * @delta: pointer to a timespec delta value
@@ -718,7 +714,6 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	clock_was_set();
 }
 
-
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  *
@@ -1003,7 +998,6 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 
 }
 
-
 /**
  * accumulate_nsecs_to_secs - Accumulates nsecs into secs
  *
@@ -1032,7 +1026,6 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 	}
 }
 
-
 /**
  * logarithmic_accumulation - shifted accumulation of cycles
  *
@@ -1076,7 +1069,6 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	return offset;
 }
 
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
@@ -1177,7 +1169,6 @@ void getboottime(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime);
 
-
 /**
  * get_monotonic_boottime - Returns monotonic time since boot
  * @ts:		pointer to the timespec to be set
@@ -1358,7 +1349,6 @@ ktime_t ktime_get_monotonic_offset(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
 
-
 /**
  * xtime_update() - advances the timekeeping infrastructure
  * @ticks:	number of ticks, that have elapsed since the last call.
-- 
1.7.9.5


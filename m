Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2GMFWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:22:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37846 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2GMFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:25 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/8] time: Whitespace cleanups per Ingo's requests
Date: Fri, 13 Jul 2012 01:21:51 -0400
Message-Id: <1342156917-25092-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-2398-0000-0000-0000087669B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted a number of places where there is inconsistent
use of whitespace. This patch tries to address the main
culprits.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 269b1fe..c2f12aa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -24,32 +24,31 @@
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
-	struct clocksource *clock;
+	struct clocksource	*clock;
 	/* NTP adjusted clock multiplier */
-	u32	mult;
+	u32			mult;
 	/* The shift value of the current clocksource. */
-	int	shift;
-
+	int			shift;
 	/* Number of clock cycles in one NTP interval. */
-	cycle_t cycle_interval;
+	cycle_t			cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
-	u64	xtime_interval;
+	u64			xtime_interval;
 	/* shifted nano seconds left over when rounding cycle_interval */
-	s64	xtime_remainder;
+	s64			xtime_remainder;
 	/* Raw nano seconds accumulated per NTP interval. */
-	u32	raw_interval;
+	u32			raw_interval;
 
 	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
-	u64	xtime_nsec;
+	u64			xtime_nsec;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
-	s64	ntp_error;
+	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
-	int	ntp_error_shift;
+	int			ntp_error_shift;
 
 	/* The current time */
-	struct timespec xtime;
+	struct timespec 	xtime;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -64,20 +63,17 @@ struct timekeeper {
 	 * - wall_to_monotonic is no longer the boot time, getboottime must be
 	 * used instead.
 	 */
-	struct timespec wall_to_monotonic;
+	struct timespec		wall_to_monotonic;
 	/* time spent in suspend */
-	struct timespec total_sleep_time;
+	struct timespec		total_sleep_time;
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec raw_time;
-
+	struct timespec		raw_time;
 	/* Offset clock monotonic -> clock realtime */
-	ktime_t offs_real;
-
+	ktime_t			offs_real;
 	/* Offset clock monotonic -> clock boottime */
-	ktime_t offs_boot;
-
+	ktime_t			offs_boot;
 	/* Seqlock for all timekeeper values */
-	seqlock_t lock;
+	seqlock_t		lock;
 };
 
 static struct timekeeper timekeeper;
@@ -547,6 +543,7 @@ u64 timekeeping_max_deferment(void)
 {
 	unsigned long seq;
 	u64 ret;
+
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085Ab2CBHNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41565 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2CBHND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 8/9] time: Whitespace cleanups per Ingo's requests
Date: Thu,  1 Mar 2012 23:12:47 -0800
Message-Id: <1330672368-32290-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-7408-0000-0000-00000324BA89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted a number of places where there is inconsistent
use of whitespace. This patch tries to address the main
culprits.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2ceee24..67983ff 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -24,34 +24,31 @@
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
+	int			shift;
 	/* cycle value at last accumulation point */
-	cycle_t cycle_last;
+	cycle_t			cycle_last;
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
-
+	u32			raw_interval;
 	/* Current CLOCK_REALTIME time in seconds */
-	u64	xtime_sec;
+	u64			xtime_sec;
 	/* Clock shifted nano seconds */
-	u64	xtime_nsec;
-
+	u64			xtime_nsec;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
-	s64	ntp_error;
+	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
-	int	ntp_error_shift;
-
+	int			ntp_error_shift;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -66,12 +63,11 @@ struct timekeeper {
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
 };
 
 static struct timekeeper timekeeper;
@@ -596,6 +592,7 @@ u64 timekeeping_max_deferment(void)
 {
 	unsigned long seq;
 	u64 ret;
+
 	do {
 		seq = read_seqcount_begin(&timekeeper_rlock);
 
-- 
1.7.3.2.146.gca209


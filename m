Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2GOI41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:56:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2GOI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:56:24 -0400
Date: Sun, 15 Jul 2012 01:56:04 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-42e71e81f5bb5125ca7c194b5ccf1c93511ff8fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1342156917-25092-3-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-3-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Whitespace cleanups per Ingo%27s requests
Git-Commit-ID: 42e71e81f5bb5125ca7c194b5ccf1c93511ff8fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 01:56:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42e71e81f5bb5125ca7c194b5ccf1c93511ff8fb
Gitweb:     http://git.kernel.org/tip/42e71e81f5bb5125ca7c194b5ccf1c93511ff8fb
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:51 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:05 +0200

time: Whitespace cleanups per Ingo%27s requests

Ingo noted a number of places where there is inconsistent
use of whitespace. This patch tries to address the main
culprits.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-3-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

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
 

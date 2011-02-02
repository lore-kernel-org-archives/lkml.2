Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1BBV4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:56:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:32779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab1BBV4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:56:02 -0500
Date: Wed, 2 Feb 2011 21:55:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134417.745627057@linutronix.de>
References: <20110201134417.745627057@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Cleanup struct initializers
Message-ID: <tip-2fd1f04089cb657c5d6c484b280ec4d3398aa157@git.kernel.org>
Git-Commit-ID: 2fd1f04089cb657c5d6c484b280ec4d3398aa157
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:55:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fd1f04089cb657c5d6c484b280ec4d3398aa157
Gitweb:     http://git.kernel.org/tip/2fd1f04089cb657c5d6c484b280ec4d3398aa157
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:03 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:12 +0100

posix-timers: Cleanup struct initializers

Cosmetic. No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134417.745627057@linutronix.de>
---
 drivers/char/mmtimer.c    |   14 +++++++-------
 kernel/posix-cpu-timers.c |   24 ++++++++++++------------
 kernel/posix-timers.c     |   38 +++++++++++++++++++-------------------
 3 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index ecd0082..fd51cd8 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -765,13 +765,13 @@ static int sgi_timer_set(struct k_itimer *timr, int flags,
 
 static struct k_clock sgi_clock = {
 	.res = 0,
-	.clock_set = sgi_clock_set,
-	.clock_get = sgi_clock_get,
-	.timer_create = sgi_timer_create,
-	.nsleep = do_posix_clock_nonanosleep,
-	.timer_set = sgi_timer_set,
-	.timer_del = sgi_timer_del,
-	.timer_get = sgi_timer_get
+	.clock_set	= sgi_clock_set,
+	.clock_get	= sgi_clock_get,
+	.timer_create	= sgi_timer_create,
+	.nsleep		= do_posix_clock_nonanosleep,
+	.timer_set	= sgi_timer_set,
+	.timer_del	= sgi_timer_del,
+	.timer_get	= sgi_timer_get
 };
 
 /**
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 05bb717..11b91dc 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1607,20 +1607,20 @@ static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
 static __init int init_posix_cpu_timers(void)
 {
 	struct k_clock process = {
-		.clock_getres = process_cpu_clock_getres,
-		.clock_get = process_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = process_cpu_timer_create,
-		.nsleep = process_cpu_nsleep,
-		.nsleep_restart = process_cpu_nsleep_restart,
+		.clock_getres	= process_cpu_clock_getres,
+		.clock_get	= process_cpu_clock_get,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= process_cpu_timer_create,
+		.nsleep		= process_cpu_nsleep,
+		.nsleep_restart	= process_cpu_nsleep_restart,
 	};
 	struct k_clock thread = {
-		.clock_getres = thread_cpu_clock_getres,
-		.clock_get = thread_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = thread_cpu_timer_create,
-		.nsleep = thread_cpu_nsleep,
-		.nsleep_restart = thread_cpu_nsleep_restart,
+		.clock_getres	= thread_cpu_clock_getres,
+		.clock_get	= thread_cpu_clock_get,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= thread_cpu_timer_create,
+		.nsleep		= thread_cpu_nsleep,
+		.nsleep_restart	= thread_cpu_nsleep_restart,
 	};
 	struct timespec ts;
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 89bff37..e7d26af 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -281,33 +281,33 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp
 static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
-		.clock_getres = hrtimer_get_res,
+		.clock_getres	= hrtimer_get_res,
 	};
 	struct k_clock clock_monotonic = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_ktime_get_ts,
-		.clock_set = do_posix_clock_nosettime,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_ktime_get_ts,
+		.clock_set	= do_posix_clock_nosettime,
 	};
 	struct k_clock clock_monotonic_raw = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_get_monotonic_raw,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_monotonic_raw,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_realtime_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_realtime_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_realtime_coarse,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_monotonic_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_monotonic_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_monotonic_coarse,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);

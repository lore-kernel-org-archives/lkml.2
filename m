Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1ALLbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:31:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:44723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1ALLbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:31:35 -0500
Date: Wed, 12 Jan 2011 11:31:11 GMT
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, hartleys@visionengravers.com, tglx@linutronix.de,
        hsweeten@visionengravers.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, hartleys@visionengravers.com,
        hsweeten@visionengravers.com
In-Reply-To: <0D753D10438DA54287A00B027084269764CE0E54B7@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B027084269764CE0E54B7@AUSP01VMBX24.collaborationhost.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping: Make local variables static
Message-ID: <tip-afa14e7c553ebe45844d76208f66017a43abd0e2@git.kernel.org>
Git-Commit-ID: afa14e7c553ebe45844d76208f66017a43abd0e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 11:31:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afa14e7c553ebe45844d76208f66017a43abd0e2
Gitweb:     http://git.kernel.org/tip/afa14e7c553ebe45844d76208f66017a43abd0e2
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Tue, 11 Jan 2011 17:59:38 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Jan 2011 12:23:13 +0100

timekeeping: Make local variables static

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <0D753D10438DA54287A00B027084269764CE0E54B7@AUSP01VMBX24.collaborationhost.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/timekeeping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5bb86da..eef7452 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -49,7 +49,7 @@ struct timekeeper {
 	u32	mult;
 };
 
-struct timekeeper timekeeper;
+static struct timekeeper timekeeper;
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -164,7 +164,7 @@ static struct timespec total_sleep_time;
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
  */
-struct timespec raw_time;
+static struct timespec raw_time;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;

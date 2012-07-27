Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2G0TUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:20:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48390 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab2G0TUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:20:32 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/5] time/jiffies changes for tip/timers/core
Date: Fri, 27 Jul 2012 14:48:08 -0400
Message-Id: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-5112-0000-0000-00000A766313
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
	Here's updated time/jiffies patches including Ingo's
feedback for tip/timers/core.

Let me know if there's any further tweaks you'd like to see.

thanks
-john

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>


Catalin Marinas (1):
  jiffies: Allow CLOCK_TICK_RATE to be undefined

John Stultz (4):
  jiffies: Rename ACTHZ to SHIFTED_HZ
  time: Stray newline cleanups
  time: Cleanup offs_real/wall_to_mono and offs_boot/total_sleep_time
    updates
  time: Remove all direct references to timekeeper

 include/linux/jiffies.h   |   29 ++--
 include/linux/timex.h     |    2 +-
 kernel/time/jiffies.c     |    2 +-
 kernel/time/ntp.c         |    2 +-
 kernel/time/timekeeping.c |  373 +++++++++++++++++++++++++--------------------
 5 files changed, 226 insertions(+), 182 deletions(-)

-- 
1.7.9.5


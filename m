Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1BVAaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:30:24 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41330 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1BVAaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:30:22 -0500
Subject: [GIT PULL] 2.6.39 CLOCK_BOOTTIME for tip/timers/core
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 16:29:56 -0800
Message-ID: <1298334596.4222.20.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here are the CLOCK_BOOTTIME changes I've been periodically sending out
for the last few weeks. It would be great to get them into
tip/timers/core for testing prior to 2.6.39.

thanks
-john

  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/core

John Stultz (5):
      hrtimers: extend hrtimer base code to handle more then 2 clockids
      time: Introduce get_monotonic_boottime and ktime_get_boottime
      time: Extend get_xtime_and_monotonic_offset() to also return sleep
      timers: Add CLOCK_BOOTTIME hrtimer base
      timers: Export CLOCK_BOOTTIME via the posix timers interface

 include/linux/hrtimer.h   |    8 +++++-
 include/linux/time.h      |    5 +++-
 kernel/hrtimer.c          |   63 ++++++++++++++++++++++++++++++--------------
 kernel/posix-timers.c     |   21 ++++++++++++++-
 kernel/time/timekeeping.c |   59 ++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 130 insertions(+), 26 deletions(-)



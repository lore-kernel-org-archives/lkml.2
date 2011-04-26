Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab1DZVho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:37:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60043 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681Ab1DZVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:37:40 -0400
Subject: [git pull] Posix Alarm Timers for 2.6.40
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:37:32 -0700
Message-ID: <1303853852.2816.135.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

Here's my Posix Alarm Timers patch queue for 2.6.40. Please let me know
if you see any issues that would block it from being merged into -tip.

thanks
-john

  git://git.linaro.org/people/jstultz/linux.git fortglx/40/tip/timer/core

John Stultz (4):
      time: Add timekeeping_inject_sleeptime
      timers: Add rb_init_node() to allow for stack allocated rb nodes
      timers: Introduce in-kernel alarm-timer interface
      timers: Posix interface for alarm-timers

 drivers/rtc/class.c          |   23 +-
 include/linux/alarmtimer.h   |   30 ++
 include/linux/capability.h   |    7 +-
 include/linux/posix-timers.h |    2 +
 include/linux/rbtree.h       |    8 +
 include/linux/time.h         |    3 +
 include/linux/timerqueue.h   |    2 +-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  705 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c    |   56 ++++-
 10 files changed, 818 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 kernel/time/alarmtimer.c



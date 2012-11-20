Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2KTDGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:06:25 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34767 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab2KTDGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:06:24 -0500
Message-ID: <50AAF392.1040103@us.ibm.com>
Date: Mon, 19 Nov 2012 19:05:54 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] time/clocksource changes for 3.8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112003-3534-0000-0000-00000F25DB07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     I wanted to send you just a few minor changes I have queued for 
3.8. Let me know if you have any objections.

thanks
-john


The following changes since commit a1c2d60889d633ffecfa9f1f7ac0bdb474b7484e:

   Merge branch 'drm-fixes' of 
git://people.freedesktop.org/~airlied/linux (2012-11-09 21:35:51 +0100)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.8/time

for you to fetch changes up to d6ad418763888f617ac5b4849823e4cd670df1dd:

   time: Kill xtime_lock, replacing it with jiffies_lock (2012-11-13 
14:08:23 -0500)

----------------------------------------------------------------
Dan Carpenter (1):
       clocksource: clean up parse_pmtmr()

John Stultz (1):
       time: Kill xtime_lock, replacing it with jiffies_lock

Lars-Peter Clausen (1):
       time/jiffies: Make clocksource_jiffies static

Linus Walleij (1):
       clocksource: arm_generic: use integer math helpers

Shan Wei (1):
       clocksource: arm_generic: use this_cpu_ptr per-cpu helper

  drivers/clocksource/acpi_pm.c     |   17 ++++++++---------
  drivers/clocksource/arm_generic.c |    6 +++---
  drivers/clocksource/i8253.c       |    2 +-
  include/linux/jiffies.h           |    3 ++-
  kernel/time/jiffies.c             |    8 +++++---
  kernel/time/tick-common.c         |    8 ++++----
  kernel/time/tick-internal.h       |    1 -
  kernel/time/tick-sched.c          |   22 +++++++++++-----------
  kernel/time/timekeeping.c         |   14 +++-----------
  9 files changed, 37 insertions(+), 44 deletions(-)


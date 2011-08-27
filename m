Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1H0Ag4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:36:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47689 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab1H0Agy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:36:54 -0400
Subject: [GIT PULL] RTC fixes for 3.1
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 17:36:49 -0700
Message-ID: <1314405409.2970.280.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo, Andrew,

	I had sent most of these out earlier, but so far have not gotten any
response on them (I know tglx has been out). Since that posting a few
more changes have been submitted, so I've added them to my tree and
wanted to re-request the pull.

You can find the changes here:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/rtc

Axel Lin (1):
      rtc: ep93xx: Fix 'rtc' may be used uninitialized warning

Ilkka Koskinen (1):
      rtc: rtc-twl: Switch to using threaded irq

John Stultz (1):
      rtc: Fix RTC PIE frequency limit

Mike Waychison (1):
      rtc: Initialized rtc_time->tm_isdst

Sebastian Reichel (1):
      rtc: rtc-twl: Remove lockdep related local_irq_enable()

Todd Poynor (1):
      rtc: twl: Fix registration vs. init order

 drivers/rtc/interface.c  |    2 +-
 drivers/rtc/rtc-ep93xx.c |   16 ++++++------
 drivers/rtc/rtc-lib.c    |    2 +
 drivers/rtc/rtc-twl.c    |   60 ++++++++++++++++++---------------------------
 include/linux/rtc.h      |    3 ++
 5 files changed, 38 insertions(+), 45 deletions(-)



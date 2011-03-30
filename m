Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1C3Djn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 23:39:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40110 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1C3Djm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 23:39:42 -0400
Subject: [git pull] RTC fixups for 2.6.39
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Jiri Pinkava <jiri.pinkava@vscht.cz>,
        MikeFrysinger <vapier@gentoo.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 20:39:29 -0700
Message-ID: <1301456369.25964.5.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

Here's a collection of RTC fixups for 2.6.39:
  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc

Let me know if you have any issues with them.
thanks
-john


John Stultz (1):
      RTC: Fix early irqs caused by calling rtc_set_alarm too early

Mike Frysinger (1):
      RTC: add missing "return 0" in new alarm func for rtc-bfin.c

Vasily Khoruzhick (1):
      RTC: Fix s3c compile error due to missing s3c_rtc_setpie

 drivers/rtc/class.c     |    2 +-
 drivers/rtc/interface.c |   26 ++++++++++++++++++++++++++
 drivers/rtc/rtc-bfin.c  |    2 ++
 drivers/rtc/rtc-s3c.c   |    2 --
 include/linux/rtc.h     |    2 ++
 5 files changed, 31 insertions(+), 3 deletions(-)




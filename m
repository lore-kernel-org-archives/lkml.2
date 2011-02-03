Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1BCWcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:32:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33013 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1BCWcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:32:17 -0500
Subject: RTC fixups for 2.6.38
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 14:32:09 -0800
Message-ID: <1296772329.3336.375.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Marcelo tested my patch queue, so I've posted it for you to pull for
2.6.38. This should resolve the regressions Marcelo pointed out.
thanks
-john

  git://git.linaro.org/people/jstultz/linux.git fortglx/2.6.38/tip/timers/rtc

John Stultz (3):
      RTC: Fix rtc driver ioctl specific shortcutting
      RTC: Convert rtc drivers to use the alarm_irq_enable method
      RTC: Fix minor compile warning

Marcelo Roberto Jimenez (1):
      RTC: Prevents a division by zero in kernel code.

 drivers/rtc/class.c          |    1 +
 drivers/rtc/interface.c      |    3 ++
 drivers/rtc/rtc-at32ap700x.c |   19 +++++-----------
 drivers/rtc/rtc-at91rm9200.c |   20 +++++++++++------
 drivers/rtc/rtc-at91sam9.c   |   20 ++++++++++++-----
 drivers/rtc/rtc-bfin.c       |   21 ++++++++++-------
 drivers/rtc/rtc-dev.c        |   21 ++++++------------
 drivers/rtc/rtc-ds1286.c     |   41 +++++++++++++++++++---------------
 drivers/rtc/rtc-ds1305.c     |   43 +++++++++++-------------------------
 drivers/rtc/rtc-ds1307.c     |   49 +++++++++++------------------------------
 drivers/rtc/rtc-ds1374.c     |   37 ++++++++-----------------------
 drivers/rtc/rtc-m41t80.c     |   30 ++++++------------------
 drivers/rtc/rtc-m48t59.c     |   21 +++++------------
 drivers/rtc/rtc-mrst.c       |   31 ++++----------------------
 drivers/rtc/rtc-msm6242.c    |    2 +-
 drivers/rtc/rtc-mv.c         |   20 ++++++-----------
 drivers/rtc/rtc-omap.c       |   28 ++++++++++++++++-------
 drivers/rtc/rtc-rp5c01.c     |    2 +-
 drivers/rtc/rtc-rs5c372.c    |   48 +++++++++++++++++++++++++++++------------
 drivers/rtc/rtc-sa1100.c     |   22 ++++++++++--------
 drivers/rtc/rtc-sh.c         |   11 ++++++---
 drivers/rtc/rtc-test.c       |   21 ++---------------
 drivers/rtc/rtc-vr41xx.c     |   38 +++++++++++++++-----------------
 23 files changed, 236 insertions(+), 313 deletions(-)



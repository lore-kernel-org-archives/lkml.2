Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1GBBVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:21:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57228 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1GBBVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:21:34 -0400
Subject: [GIT PULL] RTC changes for 3.1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 18:21:30 -0700
Message-ID: <1309569690.2872.405.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I've got a few RTC changes queued in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/rtc

Would you please consider queuing these into -tip for 3.1?

thanks
-john

Wolfram Sang (6):
      rtc: vt8500: Use define instead of hardcoded value for status bit
      rtc: stmp3xxx: Restore register definitions
      rtc: stmp3xxx: Port stmp-functions to mxs-equivalents
      rtc: stmp3xxx: Initialize drvdata before registering device
      rtc: stmp3xxx: Get rid of mach-specific accessors
      rtc: stmp3xxx: Remove UIE handlers

 drivers/rtc/Kconfig        |    6 +-
 drivers/rtc/rtc-stmp3xxx.c |  153 +++++++++++++++++++++++---------------------
 drivers/rtc/rtc-vt8500.c   |    6 +-
 3 files changed, 86 insertions(+), 79 deletions(-)



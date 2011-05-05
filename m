Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1EETeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:34:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53946 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab1EETeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:34:24 -0400
Subject: [GIT pull] rtc fixes for 2.6.39
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 12:34:19 -0700
Message-ID: <1304624059.20980.10.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here are some urgent 2.6.39 boot fixups from Wolfram for RTC devices
that register themselves before they are finished initializing.

They are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc

Wolfram Sang (3):
      rtc: mxc: fix crash on boot
      rtc: davinci: fix crash on boot
      rtc: ep93xx: fix crash on boot

 drivers/rtc/rtc-davinci.c |    5 +++--
 drivers/rtc/rtc-ep93xx.c  |    5 ++---
 drivers/rtc/rtc-mxc.c     |   19 +++++++++++--------
 3 files changed, 16 insertions(+), 13 deletions(-)



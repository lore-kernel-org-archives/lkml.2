Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2BBC4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:56:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46352 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2BBC4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:56:51 -0500
Message-ID: <1328151405.2342.113.camel@work-vm>
Subject: [GIT PULL] RTC changes for 3.4
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 18:56:45 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020202-8974-0000-0000-000005CA3410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
        Just wanted to send you my current 3.4 queue for RTC changes.
These address the issues that we had to revert similar patches for late
in the 3.2-rc period. I'm sending them now so there is enough time to
make sure any other issues that might crop up can be handled.

Again, since tip/timers/core hasn't been updated since 3.3 was out,
these are against Linus' head (actually, from a week or so ago). Let me
know if you'd like me to base them off of something else.

thanks
-john

The patches are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/rtc

John Stultz (1):
      rtc: Avoid setting alarm to a time in the past

NeilBrown (1):
      rtc: Expire alarms after the time is set. (v2)

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware (v2)

 drivers/rtc/interface.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)


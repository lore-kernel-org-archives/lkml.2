Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1INC5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 22:57:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55503 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1INC5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 22:57:46 -0400
Subject: [GIT PULL] Alarmtimers items for 3.2
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 19:57:36 -0700
Message-ID: <1315969056.18406.89.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11091402-2398-0000-0000-0000003300EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, 
	Just wanted to get the alarmtimer rework to better match the hrtimer
code as well as some alarmtimer cleanups queued into -tip for 3.2.

Let me know if you have any thoughts or issues with these patches.

thanks
-john

Commit 8bc0dafb5cf38a19484dfb16e2c6d29e85820046 is available in my git
repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/alarmtimers

John Stultz (8):
      alarmtimers: Change alarmtimer functions to return alarmtimer_restart values
      alarmtimers: Push rearming peroidic timers down into alamrtimer handler
      alarmtimers: Add alarm_forward functionality
      alarmtimers: Remove interval cap limit hack
      alarmtimers: Remove period from alarm structure
      alarmtimers: Add more refined alarm state tracking
      alarmtimers: Add try_to_cancel functionality
      alarmtimers: Rework RTC device selection using class interface

 include/linux/alarmtimer.h   |   51 ++++++++-
 include/linux/posix-timers.h |    5 +-
 kernel/time/alarmtimer.c     |  235 +++++++++++++++++++++++++++--------------
 3 files changed, 204 insertions(+), 87 deletions(-)



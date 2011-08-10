Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1HJXC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:02:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59606 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1HJXC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:02:27 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4] RTC fixes for 3.1
Date: Wed, 10 Aug 2011 16:01:54 -0700
Message-Id: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here are a few RTC fixes for 3.1. Let me know if you have any
issues with them.

These patches are also available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/rtc

Cc: Thomas Gleixner <tglx@linutronix.de>

Axel Lin (1):
  rtc: ep93xx: Fix 'rtc' may be used uninitialized warning

Ilkka Koskinen (1):
  rtc: rtc-twl: Switch to using threaded irq

John Stultz (1):
  rtc: Fix RTC PIE frequency limit

Sebastian Reichel (1):
  rtc: rtc-twl: Remove lockdep related local_irq_enable()

 drivers/rtc/interface.c  |    2 +-
 drivers/rtc/rtc-ep93xx.c |   16 ++++++++--------
 drivers/rtc/rtc-twl.c    |   10 +---------
 include/linux/rtc.h      |    3 +++
 4 files changed, 13 insertions(+), 18 deletions(-)

-- 
1.7.3.2.146.gca209


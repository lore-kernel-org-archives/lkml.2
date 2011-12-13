Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1LMUdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:33:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52250 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1LMUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:33:09 -0500
Message-ID: <1323808301.6805.4.camel@work-vm>
Subject: [GIT PULL] Few more RTC fixes for 3.2
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Matt Turner <mattst88@gmail.com>, Nico Macrionitis <acrux@cruxppc.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date: Tue, 13 Dec 2011 12:31:41 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121320-3270-0000-0000-00000288A897
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

Here are two more RTC fixes that should be considered for 3.2:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/urgent

John Stultz (1):
      rtc: m41t80: Workaround broken alarm functionality

NeilBrown (1):
      rtc: Expire alarms after the time is set.

 drivers/rtc/interface.c  |    6 ++++++
 drivers/rtc/rtc-m41t80.c |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)



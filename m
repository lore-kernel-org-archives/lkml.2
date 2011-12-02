Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1LBACS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:02:18 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49374 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1LBACR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:02:17 -0500
Message-ID: <1322784117.21423.155.camel@work-vm>
Subject: Re: [GIT PULL] RTC fixes for 3.2
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "Yang Honggang (Joseph)" <eagle.rtlinux@gmail.com>
Date: Thu, 01 Dec 2011 16:01:57 -0800
In-Reply-To: <1322019132.6445.106.camel@work-vm>
References: <1322019132.6445.106.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 11120200-5806-0000-0000-000010308E3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I just wanted to ping you again on the following fixes for 3.2. I've
added a clocksource fix as well to the queue.

The patches available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/urgent

Arve Hjønnevåg (1):
      rtc: Fix some bugs that allowed accumulating time drift in suspend/resume

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware

Yang Honggang (Joseph) (1):
      clocksource: Fix bug with max_deferment margin calculation

 drivers/rtc/class.c       |   10 +++++-----
 drivers/rtc/interface.c   |   44 ++++++++++++++++++++++++++++++++++----------
 kernel/time/clocksource.c |    4 ++--
 3 files changed, 41 insertions(+), 17 deletions(-)



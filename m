Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab1KWDcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:32:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45098 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab1KWDcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:32:20 -0500
Message-ID: <1322019132.6445.106.camel@work-vm>
Subject: [GIT PULL] RTC fixes for 3.2
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Date: Tue, 22 Nov 2011 19:32:12 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 11112303-1780-0000-0000-000001218764
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000234; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00089946; UDB=6.00024041; UTC=2011-11-23
 03:32:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I've queued two RTC fixes from Arve and Rabin for 3.2, against
tip/timers/urgent which are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/urgent

thanks
-john

Arve Hjønnevåg (1):
      rtc: Fix some bugs that allowed accumulating time drift in suspend/resume

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware

 drivers/rtc/class.c     |   10 +++++-----
 drivers/rtc/interface.c |   44 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 15 deletions(-)


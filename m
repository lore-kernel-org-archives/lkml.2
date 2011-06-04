Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1FDBHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 21:07:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41499 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1FDBHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 21:07:05 -0400
Subject: [GIT pull] RTC fixes for 3.0
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Bryan Henderson <bryanh@giraffe-data.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 18:07:00 -0700
Message-ID: <1307149620.11492.64.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, 
	Here are some RTC fixes needed for 3.0. Please take a look at them and
queue them for Linus.

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.0/tip/timers/rtc

John Stultz (1):
      rtc: Fix ioctl error path return

Mark Brown (1):
      rtc: Staticize non-exported __rtc_set_alarm()

 drivers/rtc/interface.c |    2 +-
 drivers/rtc/rtc-dev.c   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)



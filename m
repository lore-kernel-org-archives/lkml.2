Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1GBBOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:14:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44261 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1GBBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:14:52 -0400
Subject: [GIT PULL] Clocksource change for 3.1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 18:14:48 -0700
Message-ID: <1309569288.2872.398.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

	I have one clocksource patch that is available in the git repository
at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/clocksource

Would you please consider queueing this into -tip for 3.1?

thanks
-john

Jamie Iles (1):
      clocksource: apb: Share APB timer code with other platforms

 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/apb_timer.h   |   22 +--
 arch/x86/kernel/apb_timer.c        |  409 ++++++------------------------------
 drivers/clocksource/Kconfig        |    3 +
 drivers/clocksource/Makefile       |    1 +
 drivers/clocksource/dw_apb_timer.c |  401 +++++++++++++++++++++++++++++++++++
 include/linux/dw_apb_timer.h       |   56 +++++
 7 files changed, 533 insertions(+), 360 deletions(-)
 create mode 100644 drivers/clocksource/dw_apb_timer.c
 create mode 100644 include/linux/dw_apb_timer.h



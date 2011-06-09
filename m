Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab1FINI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:59778 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab1FINI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:26 -0400
Message-Id: <20110609130509.346588418@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:08:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Subject: [patch 0/5] i8253: common clockevent
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all the copies of i8253 clockevents code with a single common
implementation.

Thanks,

	tglx
---
 arch/arm/mach-footbridge/Kconfig     |    1 
 arch/arm/mach-footbridge/isa-timer.c |   51 -----------------
 arch/mips/Kconfig                    |    1 
 arch/mips/kernel/i8253.c             |   97 ---------------------------------
 arch/x86/Kconfig                     |    2 
 arch/x86/kernel/i8253.c              |   93 +-------------------------------
 drivers/clocksource/Kconfig          |    5 +
 drivers/clocksource/i8253.c          |  101 ++++++++++++++++++++++++++++++++---
 8 files changed, 107 insertions(+), 244 deletions(-)


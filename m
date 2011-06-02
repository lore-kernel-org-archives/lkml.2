Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1FBJe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:34:58 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60212 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933010Ab1FBJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:34:56 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
Date: Thu, 2 Jun 2011 11:34:31 +0200
Message-ID: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Multi Timer Unit (MTU) is currently used as clocksource and sched_clk
for the u8500 machine. The MTU block loose power during cpuidle sleep states
so an alternate clocksource is needed and these patches adds the db8500 PRCMU
timer.

Mattias Wallin (3):
  plat-nomadik: MTU sched_clock as a config option
  clocksource: add DB8500 PRCMU Timer support
  mach-ux500: Initialize the DB8500 PRCMU timer

 arch/arm/mach-ux500/cpu.c                 |    2 +
 arch/arm/plat-nomadik/Kconfig             |    8 ++-
 arch/arm/plat-nomadik/timer.c             |    4 +
 drivers/clocksource/Kconfig               |   15 +++++
 drivers/clocksource/Makefile              |    1 +
 drivers/clocksource/clksrc-db8500-prcmu.c |   90 +++++++++++++++++++++++++++++
 include/linux/clksrc-db8500-prcmu.h       |   17 ++++++
 7 files changed, 136 insertions(+), 1 deletions(-)
 create mode 100644 drivers/clocksource/clksrc-db8500-prcmu.c
 create mode 100644 include/linux/clksrc-db8500-prcmu.h

-- 
1.7.4.3


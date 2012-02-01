Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2BAQJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:09:31 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39870 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601Ab2BAQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:27 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] AB8500 fixes and AB9540 support
Date: Wed, 1 Feb 2012 17:09:07 +0100
Message-ID: <1328112547-32424-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This breaks the earlier patch to support AB9540 apart into
smaller pieces, and uses the platform device ID to enforce
which version of the ASIC is being used.

Sam: seeking ACKs for these, [1/4] could possibly go into
the -rc series if you find time for it.

Linus Walleij (4):
  mfd/ab8500: fix error path bug
  mfd/ab8500: add version detection and enforcing
  mfd/ab8500: parametrize IRQ masks and registers
  mfd/ab8500: support AB9540 variant

 arch/arm/mach-ux500/board-mop500.c                 |    1 -
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/mfd/ab8500-core.c                          |  301 ++++++++++++++++----
 drivers/mfd/ab8500-i2c.c                           |   15 +-
 include/linux/mfd/abx500.h                         |    7 -
 include/linux/mfd/abx500/ab8500-gpio.h             |    4 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |   43 +++
 include/linux/mfd/abx500/ab8500.h                  |  114 +++++++-
 include/linux/regulator/ab8500.h                   |   70 +++++-
 9 files changed, 487 insertions(+), 70 deletions(-)

-- 
1.7.8


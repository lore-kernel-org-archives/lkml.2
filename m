Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2BTUm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:42:28 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36440 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab2BTUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:42:21 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] AB8500 fixes and AB9540 support v2
Date: Mon, 20 Feb 2012 21:41:48 +0100
Message-ID: <1329770508-9451-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This fixes the comments from Maxime and Samuel:

- Isolate the fix in [1/4] so it can be pushed to the
  rc series if desired.

- Remove pointless touching of board-mop500.c in [2/4]

- Rebased the rest for simplicity to apply.

Linus Walleij (4):
  mfd/ab8500: fix error path bug
  mfd/ab8500: add version detection and enforcing
  mfd/ab8500: parametrize IRQ masks and registers
  mfd/ab8500: support AB9540 variant

 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/mfd/ab8500-core.c                          |  301 ++++++++++++++++----
 drivers/mfd/ab8500-i2c.c                           |   15 +-
 include/linux/mfd/abx500.h                         |    7 -
 include/linux/mfd/abx500/ab8500-gpio.h             |    4 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |   43 +++
 include/linux/mfd/abx500/ab8500.h                  |  114 +++++++-
 include/linux/regulator/ab8500.h                   |   70 +++++-
 8 files changed, 487 insertions(+), 69 deletions(-)

-- 
1.7.8


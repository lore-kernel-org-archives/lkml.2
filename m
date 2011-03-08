Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1CHJkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:40:22 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:54653 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab1CHJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:40:19 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/3] Driver for Texas Instruments TPS61050/61052 chips
Date: Tue, 8 Mar 2011 10:39:57 +0100
Message-ID: <1299577197-31261-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The TI TPS61050/TPS61052 chips can be used for various stuff,
boost converter (for e.g. audio), LED flash gun, and white LED
boost driver.

If the patches are OK I would prefer to merge them all through
the ux500-core tree so I can get the platform data in at the
same time, so requesting ACK from the MFD and regulator
subsystem maintainers if/when you are pleased with this.

Linus Walleij (3):
  mfd: add a core driver for TI TPS61050/TPS61052 chips
  regulator: add a subdriver for TI TPS6105x regulator portions
  mach-ux500: configure board for the TPS61052 regulator

 arch/arm/mach-ux500/board-mop500-regulators.c |   26 +++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500.c            |   14 ++
 drivers/mfd/Kconfig                           |   12 ++
 drivers/mfd/Makefile                          |    1 +
 drivers/mfd/tps6105x.c                        |  251 +++++++++++++++++++++++++
 drivers/regulator/Kconfig                     |    9 +
 drivers/regulator/Makefile                    |    2 +-
 drivers/regulator/tps6105x-regulator.c        |  220 ++++++++++++++++++++++
 include/linux/mfd/tps6105x.h                  |  101 ++++++++++
 10 files changed, 636 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps6105x.c
 create mode 100644 drivers/regulator/tps6105x-regulator.c
 create mode 100644 include/linux/mfd/tps6105x.h

-- 
1.7.3.2

Yours,
Linus Walleij

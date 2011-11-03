Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1KCRI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:08:26 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59246 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1KCRIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:08:23 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v3 0/6] mfd: TPS65910: Bug fixes and enhancements
Date: Thu,  3 Nov 2011 12:08:00 -0500
Message-Id: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes a number of small problems with the TPS65910 that
were discovered on a custom board.

Additionally, the last patch enhances the platform to driver interface.

Changes from v1 based on feedback from Mark Brown:
* Drop the patch #5 from pervious series.  It worked around a bug created by 
  another patch.
* Rework patch #6 completely.

Changes from v2:
* Enhance TPS65910 detection logic by reading a register
* Correct commit subjects to reflect correct subsystems
* Added Mark Brown's ACKs to the regulator patches


[1] https://lkml.org/lkml/2011/10/19/182
[2] https://lkml.org/lkml/2011/10/19/191

Kyle Manna (6):
  mfd: TPS65910: Handle non-existent devices
  mfd: TPS65910: Add I2C slave address macros
  mfd: TPS65910: Fix typo that clobbers genirq
  mfd: TPS65910: Move linux/gpio.h include to header
  regulator: TPS65910: Move regulator defs to header
  regulator: TPS65910: Create an array for init data

 drivers/mfd/tps65910.c                 |   25 ++++++++++++++-------
 drivers/regulator/tps65910-regulator.c |   37 ++++++++-----------------------
 include/linux/mfd/tps65910.h           |   37 +++++++++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 36 deletions(-)

-- 
1.7.5.4


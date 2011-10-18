Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1JRTAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:00:14 -0400
Received: from mail.fuel7.com ([74.222.0.51]:44536 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1JRTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:00:11 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Kyle Manna <kyle.manna@fuel7.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 0/6] mfd: TPS65910 bug fixes and enhancements
Date: Tue, 18 Oct 2011 13:26:22 -0500
Message-Id: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes a number of small problems with the TPS65910 that
were discovered on a custom board.

Additionally, the last patch enhances the platform to driver interface using the
TWL4030 series of regulators as an example.

Kyle Manna (6):
  mfd: TPS65910: Handle non-existent devices
  mfd: TPS65910: Add I2C slave address macros
  mfd: TPS65910: Fix typo that clobbers genirq
  mfd: TPS65910: Move linux/gpio.h include to header
  mfd: TPS65910: Fix tps65910_set_voltage
  mfd: TPS65910: Improve regulator init data

 drivers/mfd/tps65910.c                 |   23 ++-
 drivers/regulator/tps65910-regulator.c |  246 +++++++++++++++++++++++++-------
 include/linux/mfd/tps65910.h           |   36 +++++-
 3 files changed, 247 insertions(+), 58 deletions(-)

-- 
1.7.5.4


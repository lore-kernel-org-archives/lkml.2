Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2KEJqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:46:37 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10208 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2KEJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:46:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Nov 2012 01:46:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/2] tps80031: Add mfd and regulator driver
Date: Mon, 5 Nov 2012 15:14:16 +0530
Message-ID: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series supports mfd core and regulator driver for the
Texas Instruments TPS80031/ TPS80032 Fully Integrated Power
Management with Power Path and Battery Charger. The device
provides five configurable step-down converters, 11 general
purpose LDOs, USB OTG Module, ADC, RTC, 2 PWM, System Voltage
Regulator/Battery Charger with Power Path from USB, 32K
clock generator.

Laxman Dewangan (2):
  mfd: add TI TPS80031 mfd core driver
  regulator: tps80031: add regulator driver for tps80031

 drivers/mfd/Kconfig                    |   14 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps80031.c                 |  580 ++++++++++++++++++++++
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps80031-regulator.c |  821 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps80031.h           |  624 ++++++++++++++++++++++++
 7 files changed, 2050 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps80031.c
 create mode 100644 drivers/regulator/tps80031-regulator.c
 create mode 100644 include/linux/mfd/tps80031.h


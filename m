Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0GMGmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:42:13 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43652 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab0GMGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:42:10 -0400
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 0/3] ab8500-mfd: add regulator support
Date: Tue, 13 Jul 2010 11:51:27 +0530
Message-ID: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Sundar R Iyer (3):
  ab8500-mfd: add regulator support to ab8500 mfd device
  regulator: add support for regulators on the ab8500 MFD
  ux500: add ab8500-regulators machine specific data

 arch/arm/mach-ux500/Makefile                  |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c |  214 +++++++++++++
 drivers/mfd/ab8500-core.c                     |    4 +-
 drivers/regulator/Kconfig                     |    8 +
 drivers/regulator/Makefile                    |    1 +
 drivers/regulator/ab8500.c                    |  414 +++++++++++++++++++++++++
 include/linux/mfd/ab8500.h                    |    6 +
 include/linux/regulator/ab8500.h              |   25 ++
 8 files changed, 672 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.c
 create mode 100644 drivers/regulator/ab8500.c
 create mode 100644 include/linux/regulator/ab8500.h


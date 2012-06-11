Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2FKU5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:57:08 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:57345 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2FKU47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:56:59 -0400
Date: Mon, 11 Jun 2012 22:56:14 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH V3 0/3] i2c-nomadik changes
Message-ID: <cover.1339447570.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3:
	- fixed according to Linusw feedback (merged the patch he posted)
	- added Tested-by: Linusw on his permission

V2:
        - use linux/platform_data/i2c-nomadik.h not linux/i2c-nomadik.h
        - format patch with -M
        - added lee jones to the Cc: list (for device tree support)
        - minor rewording of the commit messages


Alessandro Rubini (3):
  i2c-nomadik: move header to <linux/platform_data/i2c-nomadik.h>
  i2c-nomadik: turn the platform driver to an amba driver
  i2c-nomadik: depend on ARM_AMBA, not PLAT_NOMADIK

 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/devices-common.h               |   24 +---
 drivers/i2c/busses/Kconfig                         |    5 +-
 drivers/i2c/busses/i2c-nomadik.c                   |  145 ++++++++++----------
 .../linux/platform_data/i2c-nomadik.h              |    6 +-
 5 files changed, 87 insertions(+), 95 deletions(-)
 rename arch/arm/plat-nomadik/include/plat/i2c.h => include/linux/platform_data/i2c-nomadik.h (91%)

-- 
1.7.7.2

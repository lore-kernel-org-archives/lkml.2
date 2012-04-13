Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2DMAKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:10:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55227 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2DMAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:10:32 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, ralf@linux-mips.org,
        linux-mips@linux-mips.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] gpio/MIPS/OCTEON: Add GPIO support for OCTEON.
Date: Thu, 12 Apr 2012 17:10:18 -0700
Message-Id: <1334275820-7791-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

There are two patches needed to add OCTEON GPIO support:

1) Select ARCH_REQUIRE_GPIOLIB.  This allows standard I2C GPIO
expanders to function, as well as being a prerequisite for the driver
for the on-chip pins.

2) The on-chip pin driver.

I'm not sure the best way to merge these, they are part MIPS and part
GPIO.  Via either maintainer is fine by me.

Thanks,


David Daney (2):
  MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
  gpio/MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO pins.

 arch/mips/Kconfig                               |    1 +
 arch/mips/include/asm/mach-cavium-octeon/gpio.h |   21 +++
 drivers/gpio/Kconfig                            |    8 +
 drivers/gpio/Makefile                           |    1 +
 drivers/gpio/gpio-octeon.c                      |  166 +++++++++++++++++++++++
 5 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/gpio.h
 create mode 100644 drivers/gpio/gpio-octeon.c

-- 
1.7.2.3


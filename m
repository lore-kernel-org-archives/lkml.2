Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1GEFLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:11:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1GEFLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:11:20 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Kevin Hilman <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [RFC/RFT 0/2] gpio: move tnetv107x gpio support to drivers/gpio
Date: Tue, 5 Jul 2011 10:40:58 +0530
Message-ID: <cover.1309840042.git.nsekhar@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves the tnetv107x GPIO support from
arch/arm/mach-davinci/ to drivers/gpio.

I do not have the tnetv107x EVM hardware so I have not been
able to test this. Any Tested-bys or Acked-bys are welcome
from those who have the hardware.

The patches apply to latest of gpio/next on Grant's tree.

Sekhar Nori (2):
  gpio/basic_mmio: add support for enable register
  davinci: use generic memory mapped gpio for tnetv107x

 arch/arm/mach-davinci/Kconfig             |    1 +
 arch/arm/mach-davinci/Makefile            |    1 -
 arch/arm/mach-davinci/devices-tnetv107x.c |   68 ++++++++++
 arch/arm/mach-davinci/gpio-tnetv107x.c    |  205 -----------------------------
 arch/arm/mach-davinci/tnetv107x.c         |    3 -
 drivers/gpio/gpio-ep93xx.c                |    2 +-
 drivers/gpio/gpio-generic.c               |   45 ++++++-
 drivers/gpio/gpio-mxc.c                   |    2 +-
 drivers/gpio/gpio-mxs.c                   |    2 +-
 include/linux/basic_mmio_gpio.h           |    5 +
 10 files changed, 121 insertions(+), 213 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/gpio-tnetv107x.c

-- 
1.7.3.2


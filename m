Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2I2KgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:36:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50620 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2I2Kfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:35:53 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <thierry.reding@avionic-design.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <omap@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 0/2] ARM: dts: AM33XX: Add ECAP and EHRPWM device tree data
Date: Sat, 29 Sep 2012 16:05:18 +0530
Message-ID: <1348914920-30737-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for device tree data for ECAP & EHRPWM
& device tree data for am335x-evm with PWM as backlight.

This has been based on [1] merged with [2] & depends on [3]
1. linux-next/master
2. linux-omap-dt/for_3.7/dts_part2
3. http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg312091.html

PWM back light tested on AM335X evm for different backlight levels.

Philip, Avinash (2):
  ARM: dts: AM33XX: Add ECAP & EHRPWM device tree nodes
  ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm

 arch/arm/boot/dts/am335x-evm.dts |   21 ++++++++++++++++
 arch/arm/boot/dts/am33xx.dtsi    |   48 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)


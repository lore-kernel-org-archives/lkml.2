Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3AGFRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:17:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40873 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3AGFRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:17:37 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/5] ARM: dts: AM33XX: lcdc support
Date: Mon, 7 Jan 2013 10:47:54 +0530
Message-ID: <cover.1357304150.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series add DT sources for AM335x SoC as well as AM335x based
boards.

As pinmux is an SoC specific detail rather than IP specific one,
addition of pin control has been done in a separate patch from
the one in which display timings are added. Also it may aid in
debugging in case of any issues.

This has been tested on AM335x based boards like AM335x EVM and
AM335x EVM-SK.

This series is based on v3.8-rc2.

This series has a dependency on,
1. Series v16 "of: add display helper" by,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
2. Series v2 "video: da8xx-fb: runtime timing configuration" by,
	me (Afzal Mohammed <afzal@ti.com>)
3. Series "video: da8xx-fb: DT support" by,
	me (Afzal Mohammed <afzal@ti.com>)

To test on AM335x, in addition to the above, following changes,
1. Patch "da8xx: Allow use by am33xx based devices" by,
	Pantelis Antoniou <panto@antoniou-consulting.com>
3. Series "HWMOD fixes for AM33xx PWM submodules and device tree nodes" by,
	Philip, Avinash <avinashphilip@ti.com>
would be required

A tree with all above for testing is available
 @git://gitorious.org/x0148406-public/linux-kernel.git da8xx-fb-dt


Regards
Afzal

Afzal Mohammed (5):
  ARM: dts: AM33XX: Add lcdc node
  ARM: dts: AM33XX: Add am335x-evm lcdc panel timings
  ARM: dts: AM33XX: Add am335x-evm lcdc pincontrol info
  ARM: dts: AM33XX: Add am335x-evmsk lcdc panel timings
  ARM: dts: AM33XX: Add am335x-evmsk lcdc pincontrol info

 arch/arm/boot/dts/am335x-evm.dts   |   55 +++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/am335x-evmsk.dts |   55 +++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/am33xx.dtsi      |    8 ++++++
 3 files changed, 116 insertions(+), 2 deletions(-)

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2HFNXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:23:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44210 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab2HFNXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:23:37 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [PATCH 0/4] arm/dts: omap: add dt data for MUSB
Date: Mon, 6 Aug 2012 18:53:11 +0530
Message-ID: <1344259395-4559-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt data for MUSB and related modules to
get MUSB working

These patches were initially part of
[PATCH v6 00/11] omap: musb: Add device tree support

These patches can be tested by applying it over
[PATCH v7 0/7] omap: musb: Add device tree support

These patches were developed on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

If it needs to be rebased on some other tree, pls let me
know.

Performed MUSB device mode testing on omap4 panda,
omap4 sdp and omap3 beagle

Kishon Vijay Abraham I (4):
  arm/dts: omap: Add omap-usb2 dt data
  arm/dts: Add twl6030-usb data
  arm/dts: Add twl4030-usb data
  arm/dts: omap: Add usb_otg and glue data

 arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
 arch/arm/boot/dts/omap4-panda.dts  |   10 ++++++++++
 arch/arm/boot/dts/omap4-sdp.dts    |   10 ++++++++++
 arch/arm/boot/dts/omap4.dtsi       |   13 +++++++++++++
 arch/arm/boot/dts/twl4030.dtsi     |   21 +++++++++++++++++++++
 arch/arm/boot/dts/twl6030.dtsi     |    5 +++++
 8 files changed, 79 insertions(+)

-- 
1.7.9.5


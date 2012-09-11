Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2IKGgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:36:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49089 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab2IKGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:36:41 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <tony@atomide.com>, <rnayak@ti.com>, <hvaibhav@ti.com>,
        <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
Date: Tue, 11 Sep 2012 12:06:18 +0530
Message-ID: <1347345381-4390-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No major change from the previous version. Just removed the
omap-usb2 dt data and sent that as a separate patch.

Rebased on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb

Kishon Vijay Abraham I (3):
  arm/dts: Add twl6030-usb data
  arm/dts: Add twl4030-usb data
  arm/dts: omap: Add usb_otg and glue data

 arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
 arch/arm/boot/dts/omap4-panda.dts  |   10 ++++++++++
 arch/arm/boot/dts/omap4-sdp.dts    |   10 ++++++++++
 arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
 arch/arm/boot/dts/twl4030.dtsi     |   21 +++++++++++++++++++++
 arch/arm/boot/dts/twl6030.dtsi     |    5 +++++
 8 files changed, 74 insertions(+)

-- 
1.7.9.5


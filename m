Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2ISJcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:32:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55319 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab2ISJco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:32:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH v3 0/3] ARM: dts: omap: add dt data for MUSB
Date: Wed, 19 Sep 2012 15:02:05 +0530
Message-ID: <1348047128-25692-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt data to get MUSB working in omap4 and omap3

Changes from v2:
* Changes the subject of all the patches to include "ARM: dts:"
* Added reg property and interrupt property for "usb_otg_hs". Previously these
  were obtained from ti,hwmods property.
* Rebased on
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git devel-dt

Changes from v1:
Just removed the omap-usb2 dt data and sent that as a separate patch.

Kishon Vijay Abraham I (3):
  ARM: dts: Add twl6030-usb data
  ARM: dts: Add twl4030-usb data
  ARM: dts: omap: Add usb_otg and glue data

 arch/arm/boot/dts/omap3-beagle-xm.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts       |    6 ++++++
 arch/arm/boot/dts/omap3-overo.dtsi    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi          |   11 +++++++++++
 arch/arm/boot/dts/omap4-panda.dts     |   10 ++++++++++
 arch/arm/boot/dts/omap4-sdp.dts       |   10 ++++++++++
 arch/arm/boot/dts/omap4.dtsi          |   12 ++++++++++++
 arch/arm/boot/dts/twl4030.dtsi        |   21 +++++++++++++++++++++
 arch/arm/boot/dts/twl6030.dtsi        |    5 +++++
 9 files changed, 87 insertions(+)

-- 
1.7.9.5


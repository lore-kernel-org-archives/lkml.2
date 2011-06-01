Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1FAN3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:29:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab1FAN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:28:51 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/4] arm: omap: usb: Hwmod and Runtime PM support for EHCI & OHCI
Date: Wed, 1 Jun 2011 18:57:23 +0530
Message-ID: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

These set of patches 
- defines the hwmod structures of ehci and ohci of omap3 and omap4 socs.
- Implements the Run time pm 
- global suspend/resume of EHCI and OHCI

Since, existing omap usbhs core driver of v3.0-rc1 release uses
the run time PM APIs, these patches enables the ehci and ohci
functionalaties.

Keshava Munegowda (4):
  arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
  arm: omap: usb: register hwmods of usbhs
  arm: omap: usb: device name change for the clk names of usbhs
  mfd: global Suspend and resume support of ehci and ohci

 arch/arm/mach-omap2/clock3xxx_data.c       |   28 ++--
 arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  184 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  153 +++++++++++++++++++++++
 arch/arm/mach-omap2/usb-host.c             |   99 ++++++----------
 drivers/mfd/omap-usb-host.c                |  105 ++++++++++++++++-
 6 files changed, 495 insertions(+), 84 deletions(-)


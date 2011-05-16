Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1EPJiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:38:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39282 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1EPJh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:37:59 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [RESEND][PATCH 0/5] arm: omap: usb: Runtime PM support for EHCI and OHCI drivers
Date: Mon, 16 May 2011 15:03:50 +0530
Message-ID: <1305538430-20957-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The Hwmod structures and Runtime PM features are implemented 
For EHCI and OHCI drivers of OMAP3 and OMAP4.
The global suspend/resume of EHCI and OHCI 
is validated on OMAP3430 sdp board with these patches.

Keshava Munegowda (5):
  arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
  arm: omap: usb: register hwmods of usbhs
  arm: omap: usb: device name change for the clk names of usbhs
  arm: omap: usb: Runtime PM support
  arm: omap: usb: global Suspend and resume support of ehci and ohci

 arch/arm/mach-omap2/clock3xxx_data.c       |   28 ++--
 arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  184 ++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  153 ++++++++++++++++++
 arch/arm/mach-omap2/usb-host.c             |   99 ++++--------
 drivers/mfd/omap-usb-host.c                |  236 +++++++++++++---------------
 6 files changed, 504 insertions(+), 206 deletions(-)


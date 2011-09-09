Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab1IIO4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:56:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46931 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256Ab1IIO4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:56:37 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/2] arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods
Date: Fri, 9 Sep 2011 20:22:45 +0530
Message-ID: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

For ehci and ohci hwmods,
the omap3 and omap4 I/O wakeup capablity is enabled.
In case of system global suspend, The ehci/ohci device 
connection/disconnection and remote wakeup wakesup the system.

This patch series is based on
1. 	I/O pads initialization to ehci and ohci hwmod
2.      Runtime PM support of usbhs of omap3 and omap4
       These patches are avilable at branch kmg-usbhs-pm
       code repository : git://gitorious.org/~kmg/mirrors/kmg-usbhs-pm.git
3.      Kevin's pm branch



Keshava Munegowda (1):
  arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods of omap3

Kishon Vijay Abraham (1):
  arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods of omap4

 arch/arm/mach-omap2/usb-host.c |  172 +++++++++++++++++++++++++++++++++-------
 1 files changed, 144 insertions(+), 28 deletions(-)


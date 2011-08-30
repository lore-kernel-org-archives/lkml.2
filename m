Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1H3OBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:01:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46135 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1H3OBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:01:41 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/2] omap: usb: I/O pads initialization to ehci and ohci hwmods
Date: Tue, 30 Aug 2011 19:27:25 +0530
Message-ID: <1314712647-30008-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

These two patches performs the I/O pad mux initialization 
to ehci and ohci hwmods for both omap3 and omap4 SOCs.
This patch series is based on 
1.	Runtime PM support of usbhs of omap3 and omap4
	These patches are avilable at branch kmg-usbhs-pm
	code repository : git://gitorious.org/~kmg/mirrors/kmg-usbhs-pm.git
2. 	Kevin's pm branch


Keshava Munegowda (1):
  arm: omap: usb: Add mux initialization to ehci and ohci hwmods for
    omap3

Kishon Vijay Abraham (1):
  arm: omap: usb: Add mux initialization to ehci and ohci hwmods for
    omap4

 arch/arm/mach-omap2/usb-host.c | 1234 ++++++++++++++++++++++++++++++----------
 1 files changed, 933 insertions(+), 301 deletions(-)


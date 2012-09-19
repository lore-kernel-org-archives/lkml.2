Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2ISKdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:33:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab2ISKdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:33:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <arnd@arndb.de>,
        <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/2] ARM: dts: Add subnode for ocp2scp
Date: Wed, 19 Sep 2012 16:02:50 +0530
Message-ID: <1348050772-27819-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains a patch to explicitly add reg property
to the ocp2scp dt node and a patch to add the subnode for ocp2scp
(omap-usb2).

Since the original patch series that adds ocp2scp driver and ocp2scp
data are merged in arm-soc, I'm sending this patch series based on the
same tree.

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git

But Benoit already pointed out that there's going to be merge conflicts
as he has sent a bunch of dt data patches to linux-omap (devel-dt) tree.
So now I'm not sure how that can be actually avoided.

Kishon Vijay Abraham I (2):
  ARM: dts: omap4: add *reg* property for ocp2scp
  ARM: dts: omap: Add omap-usb2 dt data

 .../devicetree/bindings/bus/omap-ocp2scp.txt       |   14 ++++++++++++++
 arch/arm/boot/dts/omap4.dtsi                       |    8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

-- 
1.7.9.5


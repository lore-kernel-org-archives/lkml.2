Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab2IMAJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:09:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54136 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2IMAIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:08:48 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 0/2] OMAP: mailbox initial device tree support
Date: Wed, 12 Sep 2012 19:08:16 -0500
Message-Id: <1347494898-16671-4-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347494898-16671-1-git-send-email-omar.luna@linaro.org>
References: <1347494898-16671-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow mailbox driver to function with device tree.

Tested in OMAP4 and OMAP3. OMAP2 untested.

Patch: arm/dts: OMAP2+: Add mailbox nodes, was Acked by Benoit
however it seems it wasn't picked up, so resend.

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg69121.html

Patch: OMAP: mailbox: add device tree support, there wasn't an
opposition other than to cleanup the driver too, however I got
quite some patches to send before continuing the cleanup.

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg69338.html

Omar Ramirez Luna (2):
  OMAP: mailbox: add device tree support
  arm/dts: OMAP2+: Add mailbox nodes

 .../devicetree/bindings/arm/omap/mailbox.txt       |    9 +++++++++
 arch/arm/boot/dts/omap2.dtsi                       |    5 +++++
 arch/arm/boot/dts/omap3.dtsi                       |    5 +++++
 arch/arm/boot/dts/omap4.dtsi                       |    5 +++++
 arch/arm/mach-omap2/devices.c                      |    3 +++
 arch/arm/mach-omap2/mailbox.c                      |   12 ++++++++++++
 6 files changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/mailbox.txt

-- 
1.7.9.5


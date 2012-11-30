Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2K3KJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:09:14 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59352 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab2K3KJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:09:12 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, grant.likely@secretlab.ca,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ARM/dts: omap3: Add DT support for IGEP devices
Date: Fri, 30 Nov 2012 11:08:54 +0100
Message-Id: <1354270137-31538-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IGEP technology devices are TI OMAP3 SoC based industrial embedded
and computer-on-module boards. This patch-set adds initial device
tree support for these devices.

The device tree allows to boot from an MMC/SD and are working all
the components that already have device tree support on OMAP3 SoCs:

- MMC/SD
- UARTs
- GPIO LEDs
- TWL4030 codec audio
- pinmux/pinconf pinctrl

Some peripheral are still not working such as Flash storage and
Ethernet but support for these will also be included once the
OMAP GPMC device tree binding patches hit mainline.

This is a v2 of the patch-set that solves issues pointed out by
Enric Balletbo and it is composed of the following patches:

[PATCH v2 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
[PATCH v2 2/3] ARM/dts: omap3: Add support for IGEPv2 board
[PATCH v2 3/3] ARM/dts: omap3: Add support for IGEP COM Module

Best regards,
Javier

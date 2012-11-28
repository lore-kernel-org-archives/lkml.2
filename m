Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945919Ab2K1XOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:14:50 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57053 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2K1XOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:14:48 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, grant.likely@secretlab.ca,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ARM/dts: omap3: Add DT support for IGEP devices
Date: Thu, 29 Nov 2012 00:14:23 +0100
Message-Id: <1354144466-750-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IGEP technology devices are TI OMAP3 SoC based industrial embedded
and computer-on-module boards. This patchset adds initial device
tree support for these devices.

The device trees allows to boot from an MMC and are working all the
components that already have device tree support on OMAP3 SoCs:

- MMC/SD
- UARTs
- GPIO LEDs
- TWL4030 codec audio
- pinmux/pinconf pinctrl

Some peripheral are still not working such as Flash storage and
Ethernet but support for these will also be included once the
OMAP GPMC device tree binding patches land on mainline.

The patchset is composed of the following patches:

[PATCH 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
[PATCH 2/3] ARM/dts: omap3: Add support for IGEPv2 board
[PATCH 3/3] ARM/dts: omap3: Add support for IGEP COM Module

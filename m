Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3ADQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:45:25 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:35431 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3ADQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:45:23 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 0/2] Add GPIO driver for Allwinner SoCs
Date: Fri,  4 Jan 2013 17:45:07 +0100
Message-Id: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for the GPIOs for the Allwinner SoCs supported so
far.

It comes on top of my previous pinctrl patchset, and has been tested on a
A13-Olinuxino from Olimex.

Thanks,
Maxime

Maxime Ripard (2):
  ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
  ARM: sunxi: Add the GPIOs node to the device tree

 .../devicetree/bindings/gpio/gpio-sunxi.txt        |   77 ++++++++++
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   51 +++++++
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-sunxi.c                          |  150 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                    |  106 ++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.h                    |    6 +-
 7 files changed, 396 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-sunxi.txt
 create mode 100644 drivers/gpio/gpio-sunxi.c

-- 
1.7.10.4


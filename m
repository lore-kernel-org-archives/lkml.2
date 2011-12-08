Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1LHWN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:13:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33673 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1LHWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:13:24 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC 0/3] pinctrl: add a driver for NVIDIA Tegra
Date: Thu,  8 Dec 2011 15:13:07 -0700
Message-Id: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't quite ready for merging yet; there are some issues that need
to be sorted out w.r.t. how to replace the existing Tegra pinmux driver
first. However, I figured it'd be good to get a review of the pinctrl
driver itself now that it should be complete.

The first patch is the driver. The other 2 patches are hacks that I use
to test it, just in case anyone is interested. Patch 2 would be fixed
before actually submitting, and patch 3 dropped.

Stephen Warren (3):
  pinctrl: add a driver for NVIDIA Tegra
  arm/tegra: Select PINMUX Kconfig variables
  New pinmux testing hacks

 arch/arm/boot/dts/tegra20.dtsi                   |    8 +
 arch/arm/mach-tegra/Kconfig                      |    3 +
 arch/arm/mach-tegra/include/mach/pinconf-tegra.h |   58 +
 arch/arm/mach-tegra/pinmux.c                     |    2 +
 drivers/pinctrl/Kconfig                          |   15 +
 drivers/pinctrl/Makefile                         |    3 +
 drivers/pinctrl/pinctrl-tegra.c                  |  604 ++++
 drivers/pinctrl/pinctrl-tegra.h                  |   83 +
 drivers/pinctrl/pinctrl-tegra20.c                | 2731 +++++++++++++++++
 drivers/pinctrl/pinctrl-tegra30.c                | 3387 ++++++++++++++++++++++
 10 files changed, 6894 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/pinconf-tegra.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra20.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra30.c


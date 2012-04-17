Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2DQGqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:46:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10641 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2DQGqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:46:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Apr 2012 23:46:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        cbouatmailru@gmail.com, olof@lixom.net, linus.walleij@linaro.org,
        lars@metafoo.de, bfreed@chromium.org, grundler@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 0/3] ARM: dt: tegra: add ALS and proximity sensor ISL29018
Date: Tue, 17 Apr 2012 12:15:52 +0530
Message-Id: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series of patches to enable the ALS and proximity sensor ISL29018 for
tegra_ventana.
The changes done here:
- Add vendor prefix in document.
- Fix the vendor prefix in isl29018 driver.
- Add entry for isl29018 in tegra-ventana.dts file.

Laxman Dewangan (3):
  devicetree: Document Intersil Corporation vendor prefix
  staging: iio: light: of: Fix vendor prefix of isl29018
  ARM: dt: tegra_ventana: als and proximity sensor isl29018 support

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/tegra-ventana.dts                |    6 ++++++
 drivers/staging/iio/light/isl29018.c               |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)


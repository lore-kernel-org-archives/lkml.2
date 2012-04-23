Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2DWMMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:12:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15283 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2DWMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:12:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 23 Apr 2012 05:12:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] ARM: tegra: enable ALS and proximity sensors
Date: Mon, 23 Apr 2012 17:41:32 +0530
Message-Id: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra based platform are using the Intersil's ALS and proximity sensor
ISL29018 and ISL29028.
Enabling this sensor in Tegra based platform through device tree. Following
changes are done:
- Add vendor prefix for Intersil Corporation in document.
- Change the vendor prefix in driver to reflect as per document.
- Enable the instance of the sensor in Tegra platform ventana, seaboard and
  cardhu.

Changes from V1:
- Change the vendor prefix for Intersil to "isil".
- Added irq numbers when enabling driver in dts file.

Laxman Dewangan (4):
  devicetree: Document Intersil Corporation vendor prefix
  staging: iio: light: of: Fix vendor prefix of isl29018/isl29028
  ARM: dt: tegra: enable als and proximity sensor
  ARM: tegra: defconfig: add ISL29028

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/tegra-cardhu.dts                 |    8 ++++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |    8 ++++++++
 arch/arm/boot/dts/tegra-ventana.dts                |    8 ++++++++
 arch/arm/configs/tegra_defconfig                   |    1 +
 drivers/staging/iio/light/isl29018.c               |    2 +-
 drivers/staging/iio/light/isl29028.c               |    2 +-
 7 files changed, 28 insertions(+), 2 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2LJMuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:50:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36202 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:50:00 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        amit.kachhap@gmail.com, Thomas Abraham <thomas.abraham@linaro.org>,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 0/4] regulator: s5m8767: Small fixes and device support
Date: Mon, 10 Dec 2012 18:19:38 +0530
Message-Id: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patch series contains 3 small fixes and device tree support for pmic 
component of s5m8767 regulator driver.

Amit Daniel Kachhap (4):
  regulator: s5m8767: Fix to work when platform registers less
    regulators
  regulator: s5m8767: Fix to read the first DVS register.
  regulator: s5m8767: Fix to work even if no DVS gpio present
  regulator: add device tree support for s5m8767

 .../bindings/regulator/s5m8767-regulator.txt       |  133 +++++++++++
 drivers/mfd/sec-core.c                             |   75 ++++++-
 drivers/regulator/s5m8767.c                        |  230 ++++++++++++++++++--
 include/linux/mfd/samsung/core.h                   |    3 +
 4 files changed, 424 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2CIRFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:05:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50741 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2CIRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:05:01 -0500
Date: Fri, 09 Mar 2012 18:04:44 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 0/2] i2c-s3c2410: Updates for exynos4210 and DT-based systems
To: ben-linux@fluff.org
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331312686-2077-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset reworks i2c-s3c2410 driver a bit to better handle
device tree-enabled platforms and adds two quirks required by
exynos4210-specific I2C controller used by s5p-hdmi driver.

This patchset is based on "i2c-bjdooks/for-34/i2c/i2c-samsung" branch
taken from:

  git://git.fluff.org/bjdooks/linux.git

Karol Lewandowski (1):
  i2c-s3c2410: Rework device type handling

Tomasz Stanislawski (1):
  i2c-s3c2410: Add HDMIPHY quirk for S3C2440

 .../devicetree/bindings/i2c/samsung-i2c.txt        |   10 ++-
 drivers/i2c/busses/i2c-s3c2410.c                   |   90 ++++++++++++--------
 2 files changed, 62 insertions(+), 38 deletions(-)

-- 
1.7.9


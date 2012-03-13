Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab2CMQyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:54:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58349 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2CMQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 13 Mar 2012 17:54:36 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 0/3 v2] Updates for exynos4210 and DT-based systems
To: ben-linux@fluff.org
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
 - Move unrelated code fragment to separate patch (of_match_ptr())
 - Move device-type handling to separate function and rework its
   internals a bit

This patchset reworks i2c-s3c2410 driver a bit to better handle
device tree-enabled platforms and adds two quirks required by
exynos4210-specific I2C controller used by s5p-hdmi driver.

This patchset is based on "i2c-bjdooks/for-34/i2c/i2c-samsung" branch
taken from:

  git://git.fluff.org/bjdooks/linux.git

Karol Lewandowski (3):
  i2c-s3c2410: Drop unused define
  i2c-s3c2410: Rework device type handling
  i2c-s3c2410: Add HDMIPHY quirk for S3C2440

 .../devicetree/bindings/i2c/samsung-i2c.txt        |   10 ++-
 drivers/i2c/busses/i2c-s3c2410.c                   |   93 +++++++++++++++-----
 2 files changed, 77 insertions(+), 26 deletions(-)

-- 
1.7.9


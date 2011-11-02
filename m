Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1KBOtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:49:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64630 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1KBOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:49:23 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        dmitry.torokhov@gmail.com, jic23@cam.ac.uk, aghayal@codeaurora.org,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, saaguirre@ti.com,
        hemanthv@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv5 0/5]  Add spi support for CMA3000 driver
Date: Wed,  2 Nov 2011 15:49:08 +0100
Message-Id: <1320245353-32125-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches add spi and device tree support for the cma3000 driver.

v5 of the set.

Changelog:

  v5: -Changes propossed by Grant Likely
      -Remove crm300 driver from the set
  v4: -Changes propossed by Dmitry Torokhov
  v3: -Support for device tree
      -Separate read/write spi

  v2: -Changes propossed by Jonathan Cameron
      -More fixes for the cma3000 driver

Ricardo Ribalda Delgado (5):
  input/cma3000_d0x: Support devices without pdata
  input/cma3000_d0x: Check silicon version
  input/cma3000_d0x: Keep configuration on poweroff
  input/cma3000_d0x: Add CMA3000 spi support
  input/cma3000_d0x: Match comment to name of struct

 .../devicetree/bindings/input/cma3000_d0x.txt      |   71 +++++++++
 drivers/input/misc/Kconfig                         |   14 ++-
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/cma3000_d0x.c                   |  100 +++++++++++--
 drivers/input/misc/cma3000_d0x_i2c.c               |    7 +
 drivers/input/misc/cma3000_d0x_spi.c               |  153 ++++++++++++++++++++
 include/linux/input/cma3000.h                      |    2 +-
 7 files changed, 332 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cma3000_d0x.txt
 create mode 100644 drivers/input/misc/cma3000_d0x_spi.c

-- 
1.7.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1JXUVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:21:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1JXUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:21:24 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, jic23@cam.ac.uk,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv4 0/6] Add spi support for CMA3000 driver and new driver CMR3000
Date: Mon, 24 Oct 2011 22:21:10 +0200
Message-Id: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following set of patches add spi and device tree support for the cma3000 driver and also
add support for the cmr3000 gyroscope.

v4 of the set.

Changelog:

  v4: -Changes propossed by Dmitry Torokhov
  v3: -Support for device tree
      -Separate read/write spi

  v2: -Changes propossed by Jonathan Cameron
      -More fixes for the cma3000 driver

Ricardo Ribalda Delgado (6):
  input/cma3000_d0x: Support devices without pdata
  input/cma3000_d0x: Check silicon version
  input/cma3000_d0x: Keep configuration on poweroff
  input/cma3000_d0x: Add CMA3000 spi support
  Input: add CMR3000 gyrsocope driver
  input/cma3000_d0x: Match comment to name of struct

 drivers/input/misc/Kconfig           |   38 +++-
 drivers/input/misc/Makefile          |    3 +
 drivers/input/misc/cma3000_d0x.c     |  100 +++++++-
 drivers/input/misc/cma3000_d0x_spi.c |  145 ++++++++++++
 drivers/input/misc/cmr3000_d0x.c     |  426 ++++++++++++++++++++++++++++++++++
 drivers/input/misc/cmr3000_d0x.h     |   45 ++++
 drivers/input/misc/cmr3000_d0x_spi.c |  144 ++++++++++++
 include/linux/input/cma3000.h        |    2 +-
 include/linux/input/cmr3000.h        |   54 +++++
 9 files changed, 941 insertions(+), 16 deletions(-)
 create mode 100644 drivers/input/misc/cma3000_d0x_spi.c
 create mode 100644 drivers/input/misc/cmr3000_d0x.c
 create mode 100644 drivers/input/misc/cmr3000_d0x.h
 create mode 100644 drivers/input/misc/cmr3000_d0x_spi.c
 create mode 100644 include/linux/input/cmr3000.h

-- 
1.7.7


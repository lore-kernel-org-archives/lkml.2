Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1JRI23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:28:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1JRI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:28:26 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/5] Add spi support for CMA3000 driver and new driver CMR3000
Date: Tue, 18 Oct 2011 10:28:01 +0200
Message-Id: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches add spi and device tree support for the cma3000 driver and also
add support for the cmr3000 gyroscope.

Ricardo Ribalda Delgado (5):
  input/cma3000_d0x: Support devices without pdata
  input/cma3000_d0x: Check silicon version
  input/cma3000_d0x: Keep configuration on poweroff
  input/cma3000_d0x: Add CMA3000 spi support
  Input: add CMR3000 gyrsocope driver

 drivers/input/misc/Kconfig           |   38 +++-
 drivers/input/misc/Makefile          |    3 +
 drivers/input/misc/cma3000_d0x.c     |   42 ++++-
 drivers/input/misc/cma3000_d0x_spi.c |  178 +++++++++++++++
 drivers/input/misc/cmr3000_d0x.c     |  400 ++++++++++++++++++++++++++++++++++
 drivers/input/misc/cmr3000_d0x.h     |   45 ++++
 drivers/input/misc/cmr3000_d0x_spi.c |  178 +++++++++++++++
 include/linux/input/cmr3000.h        |   54 +++++
 8 files changed, 932 insertions(+), 6 deletions(-)
 create mode 100644 drivers/input/misc/cma3000_d0x_spi.c
 create mode 100644 drivers/input/misc/cmr3000_d0x.c
 create mode 100644 drivers/input/misc/cmr3000_d0x.h
 create mode 100644 drivers/input/misc/cmr3000_d0x_spi.c
 create mode 100644 include/linux/input/cmr3000.h

-- 
1.7.7


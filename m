Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2LaLJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:09:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48374 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2LaLJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:35 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 00/10] MFD: twl-core: Cleanup part 2 for 3.9
Date: Mon, 31 Dec 2012 12:09:21 +0100
Message-ID: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Second part of the cleanup of twl-core which aims to make the code a bit more
readable.
It has been tested on: OMAP4 PandaBoard, OMAP4 Blaze, OMAP3 BeagleBoard, OMAP3
Zoom2.

Regards,
Peter
---
Peter Ujfalusi (10):
  mfd: twl-core: Clean up module id lookup and definitions
  mfd: twl-core: No need to check for invalid subchip ID
  mfd: twl-core: Use the lookup table to find the correct subchip for
    the modules
  mfd: twl-core: Allocate twl_modules dynamically
  mfd: twl-core: Do not try to call legacy mfd add_children() when
    booted with DT
  mfd: twl-core: Do not create dummy pdata when booted with DT
  mfd: twl-core: Move 'inuse' check early at probe time
  mfd: twl-core: Collect global variables behind one private structure
    (global)
  mfd: twl-core: Remove no longer valid comment regarding to write
    buffer size
  mfd: twl-core: Move twl_i2c_read/write_u8 to header as inline function
 drivers/mfd/twl-core.c  | 362 +++++++++++++++++++++---------------------------
 include/linux/i2c/twl.h |  84 +++++------
 2 files changed, 205 insertions(+), 241 deletions(-)

-- 
1.8.0.2


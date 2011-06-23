Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab1FWReJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab1FWRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:47 -0400
Date: Thu, 23 Jun 2011 13:22:46 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172246.27633.41303.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 06/35] drivers/floppy changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/floppy changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/block/floppy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 98de8f4..a12f8e1 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -187,7 +187,6 @@ static int print_unex = 1;
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
 #include <linux/io.h>
-- 
1.7.5.4


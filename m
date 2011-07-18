Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1GRNJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1GRNI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:08:59 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 06/34] drivers/floppy changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:20 -0400
Message-Id: <1310994528-26276-7-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.5.2


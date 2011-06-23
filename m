Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1FWRYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957Ab1FWRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:09 -0400
Date: Thu, 23 Jun 2011 13:24:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172408.27706.99259.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 19/35] drivers/mtd changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mtd changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/mtd/devices/m25p80.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 35180e4..e418e7e 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -25,7 +25,6 @@
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/mod_devicetable.h>
 
 #include <linux/mtd/cfi.h>
 #include <linux/mtd/mtd.h>
-- 
1.7.5.4


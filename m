Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1GRNPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:15:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1GRNJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 18/34] drivers/mtd changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:32 -0400
Message-Id: <1310994528-26276-19-git-send-email-prarit@redhat.com>
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
1.6.5.2


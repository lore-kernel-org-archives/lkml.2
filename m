Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab1FWRXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1FWRXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:00 -0400
Date: Thu, 23 Jun 2011 13:22:59 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172259.27643.25868.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 08/35] drivers/crypto changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/crypto changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/crypto/amcc/crypto4xx_sa.c |    1 -
 drivers/crypto/hifn_795x.c         |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_sa.c b/drivers/crypto/amcc/crypto4xx_sa.c
index de8a7a4..2995fe7 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.c
+++ b/drivers/crypto/amcc/crypto4xx_sa.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock_types.h>
 #include <linux/highmem.h>
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index a84250a..9ada5b5 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-- 
1.7.5.4


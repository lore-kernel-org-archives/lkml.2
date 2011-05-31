Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1EaPvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1EaPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:51:35 -0400
Date: Tue, 31 May 2011 11:51:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155134.3502.43590.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 08/35] drivers/crypto changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/crypto changes for SMBIOS and System Firmware

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
1.7.5.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1GRNRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:17:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1GRNJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 08/34] drivers/crypto changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:22 -0400
Message-Id: <1310994528-26276-9-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Cc: linux-crypto@vger.kernel.org
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
1.6.5.2


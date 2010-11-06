Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0KFTEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:04:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49893 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0KFTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:04:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JUC5k2nvGdfh0ERu4Y/IkyXoNtxtDIkQlXjDqYbZ7uVZSR1xUp35Rh/tfHKbSAHF2V
         qf6ZhbDJzstbyFzmpx+1mdzZCHOU4KamuTsxEZM8tGasB6tIgof10I89/xdn4mESnIFb
         mL/c09BO0wF3RP89ttPUvbj/FMOJFacfnkQPI=
From: Tracey Dent <tdent48227@gmail.com>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Drivers: edac: Makfile: Cleaned up Makefile
Date: Sat,  6 Nov 2010 15:05:07 -0400
Message-Id: <1289070307-2563-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/edac/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index b378139..9b53eda 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -10,16 +10,16 @@ obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 obj-$(CONFIG_EDAC_MCE)			+= edac_mce.o
 
-edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
-edac_core-objs	+= edac_module.o edac_device_sysfs.o
+edac_core-y	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
+edac_core-y	+= edac_module.o edac_device_sysfs.o
 
 ifdef CONFIG_PCI
-edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
+edac_core-y	+= edac_pci.o edac_pci_sysfs.o
 endif
 
 obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
 
-edac_mce_amd-objs			:= mce_amd.o
+edac_mce_amd-y			:= mce_amd.o
 obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
-- 
1.7.3.1.104.gc752e


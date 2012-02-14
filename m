Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407Ab2BNXg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:36:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49664 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab2BNXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:36:51 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, kurt.hackel@oracle.com,
        sjenning@linux.vnet.ibm.com, chris.mason@oracle.com,
        dan.magenheimer@oracle.com
Subject: [PATCH 6/6] staging: ramster: enable as staging driver
Date: Tue, 14 Feb 2012 15:36:23 -0800
Message-Id: <1329262583-26005-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020203.4F3AEFFA.0101,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAMster implements peer-to-peer transcendent memory, allowing a "cluster"
of kernels to dynamically pool their RAM.

Enable build of ramster as a staging driver

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/Kconfig  |    2 ++
 drivers/staging/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 25cdff3..5f7b5eb 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -132,4 +132,6 @@ source "drivers/staging/nvec/Kconfig"
 
 source "drivers/staging/media/Kconfig"
 
+source "drivers/staging/ramster/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a25f3f2..3a7b2f6 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_DRM_PSB)		+= gma500/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
+obj-$(CONFIG_RAMSTER)		+= ramster/
-- 
1.7.1


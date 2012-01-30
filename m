Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2A3Wje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:39:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41535 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2A3Wjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:39:32 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com, dan.magenheimer@oracle.com
Subject: [PATCH 6/6] staging: ramster: enable as staging driver
Date: Mon, 30 Jan 2012 14:39:19 -0800
Message-Id: <1327963159-16531-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F271C19.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1L0Suw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:50:52 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48657 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1L0Sun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:50:43 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com, dan.magenheimer@oracle.com
Subject: [PATCH 6/6] staging: ramster: enable as staging driver
Date: Tue, 27 Dec 2011 10:50:35 -0800
Message-Id: <1325011835-2190-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EFA137D.012A,ss=1,re=0.000,fgs=0
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
index 06c9081..28819c3 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -150,4 +150,6 @@ source "drivers/staging/mei/Kconfig"
 
 source "drivers/staging/nvec/Kconfig"
 
+source "drivers/staging/ramster/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index f3c5e33..f1e6ec0 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -66,3 +66,4 @@ obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_DRM_PSB)		+= gma500/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
+obj-$(CONFIG_RAMSTER)		+= ramster/
-- 
1.7.1


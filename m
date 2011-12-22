Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1LVPwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:52:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:27328 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1LVPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:52:41 -0500
Date: Thu, 22 Dec 2011 07:52:32 -0800
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com, dan.magenheimer@oracle.com
Subject: [PATCH V2 6/6] drivers/staging/ramster: enable as staging driver
Message-ID: <20111222155232.GA21503@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EF35242.0110,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 602fdd6e4a3e7d14e52ca417897c066b47bab25c Mon Sep 17 00:00:00 2001
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Wed, 21 Dec 2011 14:02:03 -0700
Subject: [PATCH V2 6/6] drivers/staging/ramster: enable as staging driver

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


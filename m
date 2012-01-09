Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab2AIWwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:52:35 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45970 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab2AIWwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:52:31 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging: add zsmalloc to Kconfig/Makefile
Date: Mon,  9 Jan 2012 16:51:57 -0600
Message-Id: <1326149520-31720-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
x-cbid: 12010922-5930-0000-0000-000003F1AD64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the new zsmalloc library to the staging Kconfig and Makefile

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/Kconfig  |    2 ++
 drivers/staging/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 25cdff3..4527cd6 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -92,6 +92,8 @@ source "drivers/staging/zram/Kconfig"
 
 source "drivers/staging/zcache/Kconfig"
 
+source "drivers/staging/zsmalloc/Kconfig"
+
 source "drivers/staging/wlags49_h2/Kconfig"
 
 source "drivers/staging/wlags49_h25/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a25f3f2..c4b60db 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_ZRAM)		+= zram/
 obj-$(CONFIG_XVMALLOC)		+= zram/
 obj-$(CONFIG_ZCACHE)		+= zcache/
+obj-$(CONFIG_ZSMALLOC)		+= zsmalloc/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_FB_SM7XX)		+= sm7xx/
-- 
1.7.5.4


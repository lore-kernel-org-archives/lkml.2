Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2BOPye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:54:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23349 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2BOPyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:54:33 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        dan.magenheimer@oracle.com
Subject: [PATCH 6/6] staging: ramster: enable as staging driver
Date: Wed, 15 Feb 2012 07:54:20 -0800
Message-Id: <1329321260-15222-7-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1329321260-15222-1-git-send-email-dan.magenheimer@oracle.com>
References: <1329321260-15222-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F3BD531.0050,ss=1,re=0.000,fgs=0
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
index b5a311b..c37dbc5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -130,4 +130,6 @@ source "drivers/staging/android/Kconfig"
 
 source "drivers/staging/telephony/Kconfig"
 
+source "drivers/staging/ramster/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 4908e46..035a035 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_MFD_NVEC)		+= nvec/
 obj-$(CONFIG_DRM_OMAP)		+= omapdrm/
 obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_PHONE)		+= telephony/
+obj-$(CONFIG_RAMSTER)		+= ramster/
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab2GYOY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:24:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab2GYOYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:24:54 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] iommu: Include linux/types.h
Date: Wed, 25 Jul 2012 16:24:49 +0200
Message-Id: <1343226290-32511-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.2
X-Provags-ID: V02:K0:Grt1pHj1v3b12qGJUqEYD21D6osik2c4EFTUCbTRmXl
 aSBMeXSal1RIqL/MVjVxynacNDrts9fUpCCIt3WUch6rN2JWnq
 EOxURJa7OJjEsCV3rIMe/ZOdkec3asgaHQI7lrJgpItBUxMdvx
 Bu86cygJL3TiV2T2P7WQ0TCJRfSJ2Wr1S4eGbtTkGtZ0HRave1
 JQBqKco9ZYBPK17hKWnifU4++YhBYgTn+IbPGNn86fetxylj/5
 qXmM96E7SVDDpP+pbMvOxqf/EDV7QVS7UfoCn1MqTxgx1uXoMg
 PFZC1MhIhdsMEhWHucGSTFPtxFthPTu4T/RkuR/pmmtM5SMInx
 /8GxBJEkJZGUxHhB+d+ZiGD5WV8/0eGZJUOfpnRjnd1GdIepgv
 65hrzFh4yRY3/6J15pBeFRp4YEcNUa2jM18CwMfovuEpdkqZkT
 2ItoM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/iommu.h header uses types defined in linux/types.h but doesn't
include it.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a71df92..9cbcc6a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -20,6 +20,7 @@
 #define __LINUX_IOMMU_H
 
 #include <linux/errno.h>
+#include <linux/types.h>
 
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
-- 
1.7.11.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2LMQzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:55:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43457 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2LMQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:55:20 -0500
Date: Fri, 14 Dec 2012 00:55:39 +0800
From: Wang YanQing <udknight@gmail.com>
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Subject: [PATCH]iommu: Include linux/err.h
Message-ID: <20121213165539.GA10948@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, joerg.roedel@amd.com,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/iommu.h header uses ERR_PTR defined
in linux/err.h but doesn't include it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..f4a49a6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -20,6 +20,7 @@
 #define __LINUX_IOMMU_H
 
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/types.h>
 
 #define IOMMU_READ	(1)
-- 
1.7.11.1.116.g8228a23

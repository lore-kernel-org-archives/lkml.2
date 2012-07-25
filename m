Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab2GYOY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:24:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2GYOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:24:55 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] iommu: Include linux/notifier.h
Date: Wed, 25 Jul 2012 16:24:50 +0200
Message-Id: <1343226290-32511-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1343226290-32511-1-git-send-email-thierry.reding@avionic-design.de>
References: <1343226290-32511-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:qHgj5xAaaHWWuRHt/S2+PPYQJKwImMqehA8TSsjcbpO
 wIaKOiD5dnPJ0xE7I2r+aF8CVZZ226bbITdH6rUqZsWbQHlRK7
 1Z1olbKen8JB5roOquoC/cNqpiloGKI4lOguJo2NbHindas67H
 xYMb8X/UeOo0oEOPWlmxFpOfxU1kOZ6iJ0BrOWUfn8kEiFCvHk
 u0dpbDc5q7vIr1fOnHjl5kCAJA0/bik56RCUgkVUziXDXUMklJ
 omEVNbNjPCFYSsJQIAWZm8e3GCjwqLLInw01TUCX4ojHZ9RxXR
 LqQac2e06Z76pN6bgvxgqQWaIlKeOE8ka0cju8gCx4Kh73+axN
 3kxtXCnL+gGN8jk+vz3qyYX1rdjjuLotCInmW1a8aU9zeORVue
 8fb3JsBGo3cbSftOKjT2bRZbf35ro97vFYf/2T1gd8TKOxVRsV
 alwT4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/iommu.h header uses types defined in linux/notifier.h but
doesn't include it.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9cbcc6a..4f64020 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -20,6 +20,7 @@
 #define __LINUX_IOMMU_H
 
 #include <linux/errno.h>
+#include <linux/notifier.h>
 #include <linux/types.h>
 
 #define IOMMU_READ	(1)
-- 
1.7.11.2


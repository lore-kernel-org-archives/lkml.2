Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1CXXrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:47:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46184 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab1CXXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LCJecjYE6jtW41o+R8CU7C5D47DEcCI/OBayU1MK904fGQ0wRQv5KRNRxOyDeX6Rfb
         RoC3msv5adcuI5UBfjUwOGVDYVQYLeLy6RRjsv5O5hCH6neJjD5MLNTaCsl0mn9VmgrU
         ZQ6zZvotdexNQ+bggAb5k+Dh6Cs/TedLP6BBU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alan@linux.intel.com
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V3]drivers:staging:gma500 Remove extra semi-colon.
Date: Thu, 24 Mar 2011 16:47:27 -0700
Message-Id: <1301010447-3348-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/gma500/psb_buffer.c |    4 ++--
 drivers/staging/gma500/psb_fb.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
index 3077f6a..4f60850 100644
--- a/drivers/staging/gma500/psb_buffer.c
+++ b/drivers/staging/gma500/psb_buffer.c
@@ -384,12 +384,12 @@ static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
 		break;
 	case TTM_PL_CI:
 		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->ci_region_start;;
+		mem->bus.base = dev_priv->ci_region_start;
 		mem->bus.is_iomem = true;
 		break;
 	case TTM_PL_RAR:
 		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->rar_region_start;;
+		mem->bus.base = dev_priv->rar_region_start;
 		mem->bus.is_iomem = true;
 		break;
 	default:
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index f67f53b..6c2b06e 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -194,7 +194,7 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct psb_gtt *pg = dev_priv->pg;
-	unsigned long phys_addr = (unsigned long)pg->stolen_base;;
+	unsigned long phys_addr = (unsigned long)pg->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 
-- 
1.7.4.1


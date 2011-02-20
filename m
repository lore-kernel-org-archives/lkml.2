Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1BTR7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:59:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58512 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1BTR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UBhSmaodhhoopv6ah/bNruLLrM9IlHWj0RkALoRST9reMcO56DN/n8pKYZuON6jkIb
         53a4JmWRZun7HWpm6wN6wxwHGC/KUovRGxA5TeYTkrDOAPYTc8iWo76DnFN8o/dugB0I
         oRNaV8BcuFoHCwI3bmpl2jfk5mIHsOgvwMGfc=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: airlied@linux.ie
Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] gpu: drm: nouveau: Remove unused variable to prevent compile warning.
Date: Sun, 20 Feb 2011 18:58:47 +0100
Message-Id: <1298224727-5474-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable "dev_priv" in function "nv50_vm_map_pgt" to
prevent compile warning.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c b/drivers/gpu/drm/nouveau/nv50_vm.c
index 459ff08..03c1a63 100644
--- a/drivers/gpu/drm/nouveau/nv50_vm.c
+++ b/drivers/gpu/drm/nouveau/nv50_vm.c
@@ -31,7 +31,6 @@ void
 nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
 		struct nouveau_gpuobj *pgt[2])
 {
-	struct drm_nouveau_private *dev_priv = pgd->dev->dev_private;
 	u64 phys = 0xdeadcafe00000000ULL;
 	u32 coverage = 0;
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1DFLYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:24:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab1DFLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Sqrozz/z9DFmkcz6bbiStbOUtl+ucjyUkqztifcKVvXJ4GyrPgVxDCT4cSHbQI3iDf
         J9wNuTrr/Dw/IAGFuRbr7uFdxyO2VaxbmVoXMKrUfN2Fu7GgS7ymexjjseCJlA2QrizV
         0kjOmKTxNSU5bmu/D1eQ9V8LMbPsStNtorVl8=
Message-ID: <4D9C4EAB.5080101@gmail.com>
Date: Wed, 06 Apr 2011 19:29:47 +0800
From: "helight.xu" <helight.xu@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: "airlied <airlied@linux.ie>; dri-devel" 
	<dri-devel@lists.freedesktop.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] fix warning: unused variable =?windows-1252?Q?=91dev=5Fp?=
 =?windows-1252?Q?riv=92_drivers/gpu/drm/nouveau/nv50=5Fvm=2Ec?=
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix warning: unused variable ‘dev_priv’ drivers/gpu/drm/nouveau/nv50_vm.c

Signed-off-by: helight <helight@zhwen.org>
---
  drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c 
b/drivers/gpu/drm/nouveau/nv50_vm.c
index 6144156..1f47c75 100644
--- a/drivers/gpu/drm/nouveau/nv50_vm.c
+++ b/drivers/gpu/drm/nouveau/nv50_vm.c
@@ -31,7 +31,6 @@ void
  nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
          struct nouveau_gpuobj *pgt[2])
  {
-    struct drm_nouveau_private *dev_priv = pgd->dev->dev_private;
      u64 phys = 0xdeadcafe00000000ULL;
      u32 coverage = 0;

-- 
1.6.0.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1FHKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:23:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60859 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab1FHKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:23:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/15] gma500: fix warnings
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 08 Jun 2011 11:11:10 +0100
Message-ID: <20110608101106.9478.87451.stgit@localhost.localdomain>
In-Reply-To: <20110608100411.9478.86672.stgit@localhost.localdomain>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_gtt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 74c5a65..1d0e242 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -78,7 +78,6 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  */
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
-        struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	struct page **pages;
@@ -490,7 +489,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 		goto out_err;
 	}
 
-	DRM_DEBUG("%s: vram kernel virtual address %p\n", dev_priv->vram_addr);
+	DRM_DEBUG("gma500: vram kernel virtual address %p\n", dev_priv->vram_addr);
 
 	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
 		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;


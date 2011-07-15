Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1GOQnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:43:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35825 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1GOQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:43:17 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/15] gma500: Fix cdv warning on unused variable
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:34:28 +0100
Message-ID: <20110715163426.28759.42829.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
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

 drivers/staging/gma500/cdv_intel_lvds.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/cdv_intel_lvds.c b/drivers/staging/gma500/cdv_intel_lvds.c
index d9478d5..988b2d0 100644
--- a/drivers/staging/gma500/cdv_intel_lvds.c
+++ b/drivers/staging/gma500/cdv_intel_lvds.c
@@ -353,8 +353,6 @@ static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
 				struct drm_display_mode *mode,
 				struct drm_display_mode *adjusted_mode)
 {
-	struct psb_intel_mode_device *mode_dev =
-	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 pfit_control;


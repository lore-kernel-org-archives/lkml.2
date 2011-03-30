Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1C3JUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:20:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51221 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932148Ab1C3JUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:20:37 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 18/18] gma500: turn on psb SDVO
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:01:54 +0100
Message-ID: <20110330090148.5897.85473.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep this as its own commit for bisection purposes

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index dc6f74a..6c75df5 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -703,9 +703,8 @@ static void psb_setup_outputs(struct drm_device *dev)
 		else
 			DRM_ERROR("DSI is not supported\n");
 	} else {
-		/* FIXME: check if SDVO init should be re-enabled */
 		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
-		/* psb_intel_sdvo_init(dev, SDVOB); */
+		psb_intel_sdvo_init(dev, SDVOB);
 	}
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list,


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1FPQzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:55:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51918 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1FPQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:55:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 29/29] gma500: drivers/staging/gma501/psb_intel_display.c: fix
 build
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 16 Jun 2011 17:43:35 +0100
Message-ID: <20110616164330.6039.77128.stgit@localhost.localdomain>
In-Reply-To: <20110616160104.6039.44019.stgit@localhost.localdomain>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 907c68e..0e9758a 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -332,7 +332,7 @@ static bool psb_intel_find_best_PLL(struct drm_crtc *crtc, int target,
 void psb_intel_wait_for_vblank(struct drm_device *dev)
 {
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-	udelay(20000);
+	mdelay(20);
 }
 
 int psb_intel_pipe_set_base(struct drm_crtc *crtc,


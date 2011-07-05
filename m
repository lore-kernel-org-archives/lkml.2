Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1GEOtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:49:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1GEOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:49:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/49] gma500: remove an un-needed check
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:40:03 +0100
Message-ID: <20110705144000.23872.25819.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is a Medfield only path

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index 3955448..e66d04a 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -589,7 +589,7 @@ static int mdfld_restore_display_registers(struct drm_device *dev, int pipe)
 		PSB_WVDC32(palette_val[i], palette_reg + (i<<2));
 	if (pipe == 1)
 		return 0;
-	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
+	if (!mdfld_panel_dpi(dev))
 		mdfld_enable_te(dev, pipe);
 	return 0;
 }


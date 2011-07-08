Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1GHIzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:55:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40034 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1GHIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:55:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/12] gma500: remove unneeded check in mdfld_crtc_mode_set()
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:45:49 +0100
Message-ID: <20110708084543.19581.66166.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

The list cursor is never NULL in a list_for_each_entry() loop.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_intel_display.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
index 1447a5b..fa84990 100644
--- a/drivers/staging/gma500/mdfld_intel_display.c
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -1093,8 +1093,6 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
 	memcpy(&psb_intel_crtc->saved_adjusted_mode, adjusted_mode, sizeof(struct drm_display_mode));
 
 	list_for_each_entry(connector, &mode_config->connector_list, head) {
-		if(!connector)
-			continue;
 			
 		encoder = connector->encoder;
 		


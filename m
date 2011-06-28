Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1F1WKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:10:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41032 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1F1WKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:10:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 29/29] gma500: fix build without backlight device support
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:09:48 +0100
Message-ID: <20110628220946.898.85598.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

Fix unmatched curly brackets when CONFIG_BACKLIGHT_CLASS_DEVICE is not
defined.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_dsi_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
index b88dfc2..e911ef2 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.c
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -527,8 +527,8 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 				backlight_update_status(psb_bd);
 			}
 		}
-	} 
 #endif
+	}
 set_prop_done:
     return 0;
 set_prop_error:


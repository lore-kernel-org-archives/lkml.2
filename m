Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1GEOtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:49:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1GEOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:49:17 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 25/49] commit ee12661199b82934552c7636b10217a9aa42958a
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:39:31 +0100
Message-ID: <20110705143929.23872.73217.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

gma500: fix build without backlight device support

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


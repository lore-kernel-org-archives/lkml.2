Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1DHPCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:02:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab1DHPCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:02:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: mjg@redhat.com
Cc: gregkh@suse.de, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] samsung-laptop: add support for N230 model
Date: Fri,  8 Apr 2011 17:02:04 +0200
Message-Id: <1302274926-25985-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
References: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[mmarek: cherry-picked from staging commit 0789b003]
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/platform/x86/samsung-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index f670db3..39f30ff 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -601,12 +601,12 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		.callback = dmi_check_cb,
 	},
 	{
-		.ident = "N150/N210/N220",
+		.ident = "N150/N210/N220/N230",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
 					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220/N230"),
+			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220/N230"),
 		},
 		.callback = dmi_check_cb,
 	},
-- 
1.7.4.1


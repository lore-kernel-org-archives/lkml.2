Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1CAP2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:28:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58367 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab1CAP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:26:58 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/8] amd64_edac: Drop redundant declarations
Date: Tue,  1 Mar 2011 16:26:49 +0100
Message-Id: <1298993216-19434-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those were moved to the mce_amd.h header.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 4ece4f4..fe2cc30 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -409,14 +409,6 @@ struct ecc_settings {
 	} flags;
 };
 
-extern const char *tt_msgs[4];
-extern const char *ll_msgs[4];
-extern const char *rrrr_msgs[16];
-extern const char *to_msgs[2];
-extern const char *pp_msgs[4];
-extern const char *ii_msgs[4];
-extern const char *htlink_msgs[8];
-
 #ifdef CONFIG_EDAC_DEBUG
 #define NUM_DBG_ATTRS 5
 #else
-- 
1.7.4.rc2


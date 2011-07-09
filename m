Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1GIGUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:20:38 -0400
Received: from mail.perches.com ([173.55.12.10]:3697 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab1GIGUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:20:31 -0400
From: Joe Perches <joe@perches.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] iwlagn: Add missing comma between constant string array
Date: Fri,  8 Jul 2011 23:20:25 -0700
Message-Id: <2c8a6e15b0f320e4b4b761ae6434862fc3c15924.1310187270.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310187270.git.joe@perches.com>
References: <cover.1310187270.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple quoted strings are concatenated without comma separators.

Make the array const while there.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7e6c463..de1a0c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1563,7 +1563,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 }
 
-static const char *desc_lookup_text[] = {
+static const char * const desc_lookup_text[] = {
 	"OK",
 	"FAIL",
 	"BAD_PARAM",
@@ -1587,7 +1587,7 @@ static const char *desc_lookup_text[] = {
 	"NMI_INTERRUPT_DATA_ACTION_PT",
 	"NMI_TRM_HW_ER",
 	"NMI_INTERRUPT_TRM",
-	"NMI_INTERRUPT_BREAK_POINT"
+	"NMI_INTERRUPT_BREAK_POINT",
 	"DEBUG_0",
 	"DEBUG_1",
 	"DEBUG_2",
-- 
1.7.6.131.g99019


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1GIGVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:21:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3692 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1GIGUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:20:30 -0400
From: Joe Perches <joe@perches.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] iwlegacy: Add missing comma between constant string array
Date: Fri,  8 Jul 2011 23:20:24 -0700
Message-Id: <36f8b5d1a32b8702941ebeda7a406188af132e9e.1310187270.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310187270.git.joe@perches.com>
References: <cover.1310187270.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple quoted strings are concatenated without comma separators.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 46242d2..1433466 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1484,7 +1484,7 @@ static const char * const desc_lookup_text[] = {
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


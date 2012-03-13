Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab2CMAxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:53:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:47948 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab2CMAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Fry, Donald H" <donald.h.fry@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 098/196] iwlagn: Support new 5000 microcode.
Date: Mon, 12 Mar 2012 20:20:11 -0400
Message-Id: <1331598109-31424-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fry, Donald H" <donald.h.fry@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.

New iwlwifi-5000 microcode requires driver support for API version 5.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d05fad4..dc191b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -48,7 +48,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 2
+#define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
-- 
1.7.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1DZVPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:43228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444Ab1DZVPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327783"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: donald.h.fry@intel.com, wey-yi.w.guy@intel.com, sgruszka@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
Message-Id: <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Fry, Donald H <donald.h.fry@intel.com>

commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.

New iwlwifi-5000 microcode requires driver support for API version 5.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -51,7 +51,7 @@
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 2
+#define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */

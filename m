Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0LIRXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:23:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:25787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab0LIRXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:23:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685557774"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 03/11] sep: sram_addr is 32 bit; this is not a kernel address, but device internal value
Date: Thu,  9 Dec 2010 09:30:31 -0800
Message-Id: <1291915831-18392-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does not have to be 64 bits wide

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver_api.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 5508769..fbbfa23 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -61,7 +61,7 @@ struct init_struct {
 	u32   message_size_in_words;
 
 	/* offset of the init message in the sep sram */
-	aligned_u64   sep_sram_addr;
+	u32   sep_sram_addr;
 
 	/* -not used- resident size in bytes*/
 	u32   unused_resident_size_in_bytes;
-- 
1.6.3.3


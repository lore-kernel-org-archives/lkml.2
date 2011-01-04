Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1ADUvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:51:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:1707 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1ADUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="589855676"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] staging: sep: Add comment to TODO to clean up un-needed debug prints
Date: Tue,  4 Jan 2011 12:56:27 -0800
Message-Id: <1294174587-19254-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/TODO |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
index 089c240..a89e7d6 100644
--- a/drivers/staging/sep/TODO
+++ b/drivers/staging/sep/TODO
@@ -3,3 +3,4 @@ Todo's so far (from Alan Cox)
   interfaces - Crypto API 'glue' is still not ready to submit
 - Clean up unused ioctls - Needs vendor help
 - Clean up unused fields in ioctl structures - Needs vendor help
+- Clean up un-needed debug prints - Started to work on this
-- 
1.6.3.3


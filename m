Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1GRIWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:22:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:31720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1GRIWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="29176475"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] pch_phub: use kernel's '%pM' format option to print MAC
Date: Mon, 18 Jul 2011 11:22:06 +0300
Message-Id: <1310977326-9362-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pch_phub.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 0fd7e77..7044756 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -594,8 +594,7 @@ static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
 
 	pch_phub_read_gbe_mac_addr(chip, mac);
 
-	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
-				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+	return sprintf(buf, "%pM\n", mac);
 }
 
 static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
-- 
1.7.5.4


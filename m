Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1IGGFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:05:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:39453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab1IGGEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:04:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789614"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 02/12 v2] staging: mei: fix register access function comments
Date: Wed,  7 Sep 2011 09:03:08 +0300
Message-Id: <1315375398-29529-3-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/mei_dev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index d7bc10c..2e11077 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -356,7 +356,7 @@ int mei_find_me_client_index(const struct mei_device *dev, uuid_le cuuid);
  * @dev: the device structure
  * @offset: offset from which to read the data
  *
- * returns the byte read.
+ * returns register value (u32)
  */
 static inline u32 mei_reg_read(struct mei_device *dev, unsigned long offset)
 {
@@ -368,7 +368,7 @@ static inline u32 mei_reg_read(struct mei_device *dev, unsigned long offset)
  *
  * @dev: the device structure
  * @offset: offset from which to write the data
- * @value: the byte to write
+ * @value: register value to write (u32)
  */
 static inline void mei_reg_write(struct mei_device *dev,
 				unsigned long offset, u32 value)
-- 
1.7.4.1


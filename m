Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1HaNrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:47:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab1HaNoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44294830"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 02/12] staging: mei: fix register access function comments
Date: Wed, 31 Aug 2011 16:42:38 +0300
Message-Id: <1314798168-15613-3-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
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


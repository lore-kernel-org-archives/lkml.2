Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1HaNof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:44:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab1HaNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44295040"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 11/12] staging: mei: adding mei_wd_stop function comment
Date: Wed, 31 Aug 2011 16:42:47 +0300
Message-Id: <1314798168-15613-12-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/wd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 6e132cd..3ca6d08 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -120,6 +120,16 @@ int mei_wd_send(struct mei_device *dev)
 	return -EIO;
 }
 
+/**
+ * mei_wd_stop - sends watchdog stop message to fw.
+ *
+ * @dev: the device structure
+ * @preserve: indicate if to keep the timeout value
+ *
+ * returns 0 if success,
+ *	-EIO when message send fails
+ *	-EINVAL when invalid message is to be sent
+ */
 int mei_wd_stop(struct mei_device *dev, bool preserve)
 {
 	int ret;
-- 
1.7.4.1


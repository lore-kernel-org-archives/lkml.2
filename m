Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1IGGGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:06:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab1IGGFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789737"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 11/12 v2] staging: mei: adding mei_wd_stop function comment
Date: Wed,  7 Sep 2011 09:03:17 +0300
Message-Id: <1315375398-29529-12-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/wd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index b56b1cc..ffca7ca 100644
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


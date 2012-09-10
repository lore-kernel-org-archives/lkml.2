Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2IJVnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:43:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:52047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab2IJVn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="191072281"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: struct mei_message_data doesn't have to be packed
Date: Tue, 11 Sep 2012 00:43:21 +0300
Message-Id: <1347313402-24606-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
References: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 96d3e79..adb35fb 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -140,7 +140,7 @@ enum mei_cb_major_types {
 struct mei_message_data {
 	u32 size;
 	unsigned char *data;
-} __packed;
+};
 
 
 struct mei_cl_cb {
-- 
1.7.4.4


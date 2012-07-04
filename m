Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2GDQ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:26:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab2GDQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:25:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923211"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/6] mei: mei_wd_host_init: update the comment
Date: Wed,  4 Jul 2012 19:24:51 +0300
Message-Id: <1341419094-4204-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
References: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/wd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index ae60c3f..5133fd7 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -53,11 +53,12 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 }
 
 /**
- * host_init_wd - mei initialization wd.
+ * mei_wd_host_init - connect to the watchdog client
  *
  * @dev: the device structure
  * returns -ENENT if wd client cannot be found
  *         -EIO if write has failed
+ *         0 on success
  */
 int mei_wd_host_init(struct mei_device *dev)
 {
-- 
1.7.4.4


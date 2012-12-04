Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2LDOFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2LDOE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:04:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975270"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/15] mei: move internal host clients ids to mei_dev.h from hw.h
Date: Tue,  4 Dec 2012 16:04:32 +0200
Message-Id: <1354629884-3202-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Internal clients numbers are implementation detail
and not hardware defined

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h      |    5 -----
 drivers/misc/mei/mei_dev.h |    6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index be8ca6b..7d47366 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -31,11 +31,6 @@
 #define MEI_IAMTHIF_STALL_TIMER    12  /* HPS */
 #define MEI_IAMTHIF_READ_TIMER     10  /* HPS */
 
-/*
- * Internal Clients Number
- */
-#define MEI_WD_HOST_CLIENT_ID          1
-#define MEI_IAMTHIF_HOST_CLIENT_ID     2
 
 /*
  * MEI device IDs
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index da09805..39cd289 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -72,6 +72,12 @@ extern const u8 mei_wd_state_independence_msg[3][4];
  */
 #define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 3)
 
+/*
+ * Internal Clients Number
+ */
+#define MEI_WD_HOST_CLIENT_ID          1
+#define MEI_IAMTHIF_HOST_CLIENT_ID     2
+
 
 /* File state */
 enum file_state {
-- 
1.7.4.4


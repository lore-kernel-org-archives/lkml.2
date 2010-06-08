Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0FHDv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:51:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2765 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab0FHDuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:50 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] drivers/usb/storage/isd200.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:43 -0700
Message-Id: <5920598e3cae9d1c311dd4a23c54156f72e41746.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/storage/isd200.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index e9cbc14..6b9982c 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1456,8 +1456,7 @@ static int isd200_init_info(struct us_data *us)
 	int retStatus = ISD200_GOOD;
 	struct isd200_info *info;
 
-	info = (struct isd200_info *)
-			kzalloc(sizeof(struct isd200_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct isd200_info), GFP_KERNEL);
 	if (!info)
 		retStatus = ISD200_ERROR;
 	else {
-- 
1.7.1.244.gbdc4


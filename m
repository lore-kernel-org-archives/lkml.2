Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2BBNgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:36:15 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:55776
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753478Ab2BBNgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:36:14 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] scsi: Fix typo in mvumi.c
Date: Thu,  2 Feb 2012 22:34:43 +0900
Message-Id: <1328189683-1722-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "resouce" to "resource" in
drivers/scsi/mvumi.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/mvumi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..787d9bd 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -122,7 +122,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
-			"Failed to allocate memory for resouce manager.\n");
+			"Failed to allocate memory for resource manager.\n");
 		return NULL;
 	}
 
-- 
1.7.6.5


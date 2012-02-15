Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2BOPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:51:52 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:58055
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751792Ab2BOPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:51:49 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] scsi: Fix typo in pmcraid.h
Date: Thu, 16 Feb 2012 00:48:38 +0900
Message-Id: <1329320918-2745-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "thresold" to "threshold" in
drivers/scsi/pmraid.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/pmcraid.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index ca496c7..e1d150f 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -857,11 +857,11 @@ static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
 	{0x01180600, IOASC_LOG_LEVEL_HARD,
 	 "Recovered Error, soft media error, sector reassignment suggested"},
 	{0x015D0000, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, failure prediction thresold exceeded"},
+	 "Recovered Error, failure prediction threshold exceeded"},
 	{0x015D9200, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x015D9200, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x02048000, IOASC_LOG_LEVEL_HARD,
 	 "Not Ready, IOA Reset Required"},
 	{0x02408500, IOASC_LOG_LEVEL_HARD,
-- 
1.7.6.5


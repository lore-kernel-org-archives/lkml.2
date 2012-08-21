Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab2HUUgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:36:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53465 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2HUUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:31 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] PM / Freezer: Fix small typo "regrigerator"
Date: Tue, 21 Aug 2012 22:36:15 +0200
Message-Id: <1345581376-7288-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed when digging into a suspend issue in linux-next (next-20120821).

For more details see <http://marc.info/?t=134554708000002&r=1&w=2>.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 19db29f..87da817 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -79,7 +79,7 @@ static int try_to_freeze_tasks(bool user_only)
 
 		/*
 		 * We need to retry, but first give the freezing tasks some
-		 * time to enter the regrigerator.
+		 * time to enter the refrigerator.
 		 */
 		msleep(10);
 	}
-- 
1.7.9.5


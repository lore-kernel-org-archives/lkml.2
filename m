Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1HWQ2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:28:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:39990 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HWQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:28:28 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]mm/vmscan.c Fix a typo in a comment "relaimed" to "reclaimed"
Date: Tue, 23 Aug 2011 09:28:02 -0700
Message-Id: <1314116882-27412-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo I noticed in a comment while reading.
(Note: I looked through everything, so hopefully I didnt forget anything).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ef6912..0ea8055 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1423,7 +1423,7 @@ static inline bool should_reclaim_stall(unsigned long nr_taken,
 	if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)
 		return false;
 
-	/* If we have relaimed everything on the isolated list, no stall */
+	/* If we have reclaimed everything on the isolated list, no stall */
 	if (nr_freed == nr_taken)
 		return false;
 
-- 
1.7.6


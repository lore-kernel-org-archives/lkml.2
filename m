Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab1CXUT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:29 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64591 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189Ab1CXUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r85+lB5VDGuW/PstLk5CwrY4PFr7+7ctXSsIvZmRiRJOM3XrR77APK6kfUoEAGZ+H1
         SLNoqVTjF90FlE6XDkr4jJwhJ27mnWbyW4WBtOU61uCf0OuzIZ+lJnrFaj1jWx2O6bHw
         dxgw6tcJDKq/SXWBiN766e4/1j2VUg4vfusUs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 18/21]mm:hugetlb.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:37 -0700
Message-Id: <1300997920-31573-18-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 06de5aa..51e49fe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -475,7 +475,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;;
+		goto err;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
-- 
1.7.4.1


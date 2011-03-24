Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab1CXT2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:28:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab1CXT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W9xcKYUEbVrG2fqwkVG9k/3wyx+P9NT+3XbSMoiKsS9ilw22mAiYKiWp7AVAwPhMfp
         gcKbtvv8yG7sDnTahEqIhe0U5zktz8YRzQvFo2E72W7Cmi95pkkvS6HBhV/i6NBwy5YG
         2IFqkhWmPf3P5Z9IuSW+o9DFOHBSewZ4xNoH8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 18/21]mm:hugetlb.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:56 -0700
Message-Id: <1300994819-30930-18-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
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


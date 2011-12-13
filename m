Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1LMGgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:36:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44948 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1LMGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:36:05 -0500
Message-ID: <4EE6F24B.7050204@gmail.com>
Date: Tue, 13 Dec 2011 14:35:55 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/hugetlb.c: cleanup to use long vars instead of int in
 region_count
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

args f & t and fields from & to of struct file_region are defined
as long. Use long instead of int to type the temp vars.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/hugetlb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dae27ba..e666287 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -195,8 +195,8 @@ static long region_count(struct list_head *head, long f, long t)
 
 	/* Locate each segment we overlap with, and count that overlap. */
 	list_for_each_entry(rg, head, link) {
-		int seg_from;
-		int seg_to;
+		long seg_from;
+		long seg_to;
 
 		if (rg->to <= f)
 			continue;
-- 
1.7.1


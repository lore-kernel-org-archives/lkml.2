Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2E1PUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:20:39 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59356 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2E1PUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:20:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mm/hugetlb: Add documentation for hugetlb limit fail count interface
Date: Mon, 28 May 2012 20:50:24 +0530
Message-Id: <1338218424-30864-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12052815-5564-0000-0000-000002FAC747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Document memory.hugetlb.<x>.failcnt interface

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Documentation/cgroups/memory.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 730e222a..3a47ec5 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -80,6 +80,7 @@ Brief summary of control files.
  memory.hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
  memory.hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
 						  # see 5.7 for details
+ memory.hugetlb.<hugepagesize>.failcnt		  # show the number of allocation failure due to HugeTLB limit
 
 1. History
 
-- 
1.7.10


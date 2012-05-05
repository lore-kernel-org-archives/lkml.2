Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab2EEDmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:42:14 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57026 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2EEDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:42:12 -0400
Date: Sat, 5 May 2012 11:42:05 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] Correct the comment of allocate_resource()
Message-ID: <20120505034205.GA4447@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050417-5490-0000-0000-000001488795
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the comment of allocate_resource(), the explanation of parameter max
and min is not correct.

Actually, this two parameter is used to specify the range of the resource
will be allocated, not the min/max size will be allocated.

Signed-Off-By: Wei Yang <weiyang@linux.vnet.ibm.com>

---
 kernel/resource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..e1d2b8e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -515,8 +515,8 @@ out:
  * @root: root resource descriptor
  * @new: resource descriptor desired by caller
  * @size: requested resource region size
- * @min: minimum size to allocate
- * @max: maximum size to allocate
+ * @min: minimum boundary to allocate
+ * @max: maximum boundary to allocate
  * @align: alignment requested, in bytes
  * @alignf: alignment function, optional, called if not NULL
  * @alignf_data: arbitrary data to pass to the @alignf function
-- 
1.7.4.1


-- 
Richard Yang
Help you, Help me


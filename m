Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2CGMLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:52 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39604 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab2CGMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:42 -0500
Message-ID: <4F575073.60909@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 20:11:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] rmap: remove __anon_vma_link
References: <4F575045.9010904@linux.vnet.ibm.com>
In-Reply-To: <4F575045.9010904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030712-5816-0000-0000-0000019FBEB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This declaration is not used anymore, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/rmap.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 1cdd62a..fd07c45 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -122,7 +122,6 @@ void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 void anon_vma_moveto_tail(struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-void __anon_vma_link(struct vm_area_struct *);

 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
-- 
1.7.7.6


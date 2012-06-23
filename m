Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2FWKHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:07:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2FWKFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:47 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Kautuk Consul <consul.kautuk@gmail.com>, linux-mm@kvack.org
Subject: [PATCH 11/12] vmalloc: remove KM_USER0 from comments
Date: Sat, 23 Jun 2012 18:04:22 +0800
Message-Id: <1340445863-16111-12-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 mm/vmalloc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2aad499..c7ac8e1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1975,9 +1975,7 @@ static int aligned_vwrite(char *buf, char *addr, unsigned long count)
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
  *	If [addr...addr+count) doesn't includes any intersects with alive
- *	vm_struct area, returns 0.
- *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
- *	the caller should guarantee KM_USER0 is not used.
+ *	vm_struct area, returns 0. @buf should be kernel's buffer.
  *
  *	Note: In usual ops, vread() is never necessary because the caller
  *	should know vmalloc() area is valid and can use memcpy().
@@ -2051,9 +2049,7 @@ finished:
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
  *	If [addr...addr+count) doesn't includes any intersects with alive
- *	vm_struct area, returns 0.
- *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
- *	the caller should guarantee KM_USER0 is not used.
+ *	vm_struct area, returns 0. @buf should be kernel's buffer.
  *
  *	Note: In usual ops, vwrite() is never necessary because the caller
  *	should know vmalloc() area is valid and can use memcpy().
-- 
1.7.7.6


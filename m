Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0JVM3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:29:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43433 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0JVM3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZzwsjidvdFO928nmMQdPiq+dbN4lR9FkS2k1SWQVBQbZUhZcgOOL8mQtOTuf9ec3Yz
         /2acfhvqIczXCIIdXqVzh+F1ioWXe/VAGHxgUMPgTkun1Ewg+NB4ftvgsVkNcyjKdTat
         Ca7ICPn+ka7Qms3jUptQBF+eDSZO6vdD/bK9o=
From: Liu Aleaxander <aleaxander@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Liu Aleaxander <Aleaxander@gmail.com>
Subject: [PATCH] mm: fix the wrong comments for kunmap_high
Date: Fri, 22 Oct 2010 20:29:19 +0800
Message-Id: <1287750559-2942-1-git-send-email-Aleaxander@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the wrong function descrption for kunmap_high function

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 mm/highmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 7a0aa1b..a0bc98f 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -242,7 +242,7 @@ void *kmap_high_get(struct page *page)
 #endif
 
 /**
- * kunmap_high - map a highmem page into memory
+ * kunmap_high - unmap a highmem page into memory
  * @page: &struct page to unmap
  *
  * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
-- 
1.7.0.1


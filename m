Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1HYOMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:12:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34564 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1HYOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:12:52 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH -mmotm] lib/string.c: fix kernel-doc for memchr_inv
Date: Thu, 25 Aug 2011 23:14:40 +0900
Message-Id: <1314281680-21553-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes kernel-doc for memchr_inv() which is introduced by
lib-stringc-introduce-memchr_inv.patch in mmotm 2011-08-24-14-08

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>
---
 lib/string.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 18f5111..11df543 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -769,10 +769,10 @@ static void *check_bytes8(const u8 *start, u8 value, unsigned int bytes)
 }
 
 /**
- * memchr_inv - Find a character in an area of memory.
- * @s: The memory area
- * @c: The byte to search for
- * @n: The size of the area.
+ * memchr_inv - Find an unmatching character in an area of memory.
+ * @start: The memory area
+ * @c: Find a character other than c
+ * @bytes: The size of the area.
  *
  * returns the address of the first character other than @c, or %NULL
  * if the whole buffer contains just @c.
-- 
1.7.4.4


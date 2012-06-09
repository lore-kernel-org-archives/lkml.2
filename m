Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2FICXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:23:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2FICXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:23:11 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] lib: correct link to the original source for div64_u64
Date: Sat,  9 Jun 2012 11:22:47 +0900
Message-Id: <1339208567-18089-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>
---
 lib/div64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/div64.c b/lib/div64.c
index 3ea2490..a163b6c 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(div_s64_rem);
  * by the book 'Hacker's Delight'.  The original source and full proof
  * can be found here and is available for use without restriction.
  *
- * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c'
+ * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
  */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
-- 
1.7.7.6


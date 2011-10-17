Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1JQU3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:29:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52826 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1JQU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:29:10 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: [PATCH] lib/raid6: Fix filename emitted in generated code
Date: Mon, 17 Oct 2011 15:29:08 -0500
Message-Id: <1318883348-29961-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The files were renamed in commit cc4589ebf; fix the name in the file
itself.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 lib/raid6/int.uc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index d1e276a..5b50f8d 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * raid6int$#.c
+ * int$#.c
  *
  * $#-way unrolled portable integer math RAID-6 instruction set
  *
-- 
1.7.7


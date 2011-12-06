Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1LFXUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:20:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56646 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1LFXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:20:05 -0500
From: Mark Einon <mark.einon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] [TRIVIAL] linux-next: Fixed spelling typo in types.h
Date: Tue,  6 Dec 2011 23:18:14 +0000
Message-Id: <1323213494-21947-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling change, architetures -> architectures

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 include/linux/types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 57a9723..cbcef6e 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -188,7 +188,7 @@ typedef __u32 __bitwise __wsum;
  * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
  * common 32/64-bit compat problems.
  * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
- * architectures) and to 8-byte boundaries on 64-bit architetures.  The new
+ * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
  * aligned_64 type enforces 8-byte alignment so that structs containing
  * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
  * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
-- 
1.7.7.3


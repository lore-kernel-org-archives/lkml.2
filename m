Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1CXOuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:50:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51803 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab1CXOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:50:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=MHIHeT4tFIWX7/Y9kCWTeTMSt/NOUXMJBgahleTsYbhnf+VxiPDm1bztHfLrMKmJwX
         K4FrR0Y526i/yLRvTLlLn6p6y6j/xrdeMeKIrAI5Hhh6xfJc+dRQbPFoXFHuD1XjwUQB
         y0dnunEQyZlZyy3W9Sr7RXiDIvfTzXsYvlvPc=
From: Daniel Baluta <dbaluta@ixiacom.com>
To: catalin.marinas@arm.com, rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] kmemleak: update documentation
Date: Thu, 24 Mar 2011 16:49:33 +0200
Message-Id: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides x86 and arm, kmemleak now supports powerpc, sparc, sh,
microblaze and tile.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 Documentation/kmemleak.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 34f6638..090e6ee 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -11,6 +11,7 @@ with the difference that the orphan objects are not freed but only
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
 
 Usage
 -----
@@ -178,5 +179,4 @@ block doesn't need to be freed (some cases in the init_call functions),
 the pointer is calculated by other methods than the usual container_of
 macro or the pointer is stored in a location not scanned by kmemleak.
 
-Page allocations and ioremap are not tracked. Only the ARM and x86
-architectures are currently supported.
+Page allocations and ioremap are not tracked.
-- 
1.7.1


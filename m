Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1CZWiC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 18:38:02 -0400
Received: from mail.perches.com ([173.55.12.10]:4287 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1CZWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 18:37:46 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] MAINTAINERS: Update m68knommu patterns
Date: Sat, 26 Mar 2011 15:37:42 -0700
Message-Id: <1d67762792f7d409375f5a29c2159f39164ac166.1301178998.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 66d857b08b ("m68k: merge m68k and m68knommu arch directories")
moved the files around.

cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fb9017..735f124 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6274,7 +6274,8 @@ M:	Greg Ungerer <gerg@uclinux.org>
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
-F:	arch/m68knommu/
+F:	arch/m68k/*/*_no.*
+F:	arch/m68k/include/asm/*_no.*
 
 UCLINUX FOR RENESAS H8/300 (H8300)
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
-- 
1.7.4.2.g597a6.dirty


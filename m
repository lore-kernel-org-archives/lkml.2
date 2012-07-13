Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674Ab2GMQjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030540Ab2GMQjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:39:00 -0400
Date: Sat, 14 Jul 2012 01:38:57 +0900 (JST)
Message-Id: <20120714.013857.842207598293397977.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] trivial: typo in comment in mksysmap
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 scripts/mksysmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 6e133a0..c1b6191 100644
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -16,7 +16,7 @@
 #   The second row specify the type of the symbol:
 #   A = Absolute
 #   B = Uninitialised data (.bss)
-#   C = Comon symbol
+#   C = Common symbol
 #   D = Initialised data
 #   G = Initialised data for small objects
 #   I = Indirect reference to another symbol
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab0FIVjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:39:04 -0400
Received: from mail.perches.com ([173.55.12.10]:2972 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab0FIVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:39:00 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH] MAINTAINERS: Add file patterns to UCLINUX FOR RENESAS H8/300
Date: Wed,  9 Jun 2010 14:38:59 -0700
Message-Id: <d3d1f4903e9c525e3fd97cee7e3b0633a2dcacbd.1276118492.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 MAINTAINERS |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb3a7d6..d462530 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5698,6 +5698,9 @@ UCLINUX FOR RENESAS H8/300 (H8300)
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
+F:	arch/h8300/
+F:	drivers/ide/ide-h8300.c
+F:	drivers/net/ne-h8300.c
 
 UDF FILESYSTEM
 M:	Jan Kara <jack@suse.cz>
-- 
1.7.1.244.gbdc4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0INEZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2012 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0INEYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH next 14/16] fs: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:24:00 -0700
Message-Id: <874c4a1eded03516d6ea5c110fbd603c76052845.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/binfmt_flat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 811384b..d53e0d6 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -382,7 +382,9 @@ failed:
 void old_reloc(unsigned long rl)
 {
 #ifdef DEBUG
-	char *segment[] = { "TEXT", "DATA", "BSS", "*UNKNOWN*" };
+	static const char * const segment[] = {
+		"TEXT", "DATA", "BSS", "*UNKNOWN*"
+	};
 #endif
 	flat_v2_reloc_t	r;
 	unsigned long *ptr;
-- 
1.7.3.rc1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615Ab0GSLRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:17:10 -0400
Received: from norkia.v3.sk ([91.210.183.14]:54001 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760572Ab0GSLRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:17:00 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lubomir Rintel <lkundrak@v3.sk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] [fs/sysv] Add v7 alias
Date: Mon, 19 Jul 2010 19:16:40 +0200
Message-Id: <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that the module gets autoloaded when a v7 filesystem is mounted.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/sysv/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..bd8d141 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -560,4 +560,5 @@ static void __exit exit_sysv_fs(void)
 
 module_init(init_sysv_fs)
 module_exit(exit_sysv_fs)
+MODULE_ALIAS("v7");
 MODULE_LICENSE("GPL");
-- 
1.6.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab2AJAMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:12:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab2AJALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:11:35 -0500
Date: Tue, 10 Jan 2012 03:07:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block_dev: Remove kmemleak header include
Message-ID: <20120110000752.GB3127@swordfish>
References: <20120109224436.GA3429@swordfish>
 <20120109230316.GZ23916@ZenIV.linux.org.uk>
 <20120109234359.GA3127@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109234359.GA3127@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_dev: Remove kmemleak header include

No need to include kmemleak.h header, since the only kmemleak
function call has been deleted from bdev_cache_init().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69a5b6f..ce87d2a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -25,7 +25,6 @@
 #include <linux/uio.h>
 #include <linux/namei.h>
 #include <linux/log2.h>
-#include <linux/kmemleak.h>
 #include <linux/cleancache.h>
 #include <asm/uaccess.h>
 #include "internal.h"

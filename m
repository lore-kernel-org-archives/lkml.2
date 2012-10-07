Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2JGPIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:08:45 -0400
Received: from mail.servus.at ([193.170.194.20]:53308 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2JGPIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:08:37 -0400
Date: Sun, 7 Oct 2012 17:08:33 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
To: linux-kernel@vger.kernel.org
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: [PATCH 1/3] lib/lzo: Rename lzo1x_decompress.c to
 lzo1x_decompress_safe.c
Message-ID: <7c979cebc0f93dc692b734c12665a6824d219c20.1349621096.git.markus@oberhumer.com>
References: <cover.1349621096.git.markus@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1349621096.git.markus@oberhumer.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the source file to match the function name and thereby
also make room for a possible future even slightly faster
"non-safe" decompressor version.

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>
---
 lib/lzo/Makefile                                   |    2 +-
 ...{lzo1x_decompress.c => lzo1x_decompress_safe.c} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename lib/lzo/{lzo1x_decompress.c => lzo1x_decompress_safe.c} (100%)

diff --git a/lib/lzo/Makefile b/lib/lzo/Makefile
index e764116..f0f7d7c 100644
--- a/lib/lzo/Makefile
+++ b/lib/lzo/Makefile
@@ -1,5 +1,5 @@
 lzo_compress-objs := lzo1x_compress.o
-lzo_decompress-objs := lzo1x_decompress.o
+lzo_decompress-objs := lzo1x_decompress_safe.o
 
 obj-$(CONFIG_LZO_COMPRESS) += lzo_compress.o
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo_decompress.o
diff --git a/lib/lzo/lzo1x_decompress.c b/lib/lzo/lzo1x_decompress_safe.c
similarity index 100%
rename from lib/lzo/lzo1x_decompress.c
rename to lib/lzo/lzo1x_decompress_safe.c
-- 
1.7.1


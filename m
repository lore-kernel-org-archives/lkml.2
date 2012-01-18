Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2ARW1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:27:51 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48381 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2ARW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:27:50 -0500
Subject: [PATCH 01/13] crc32: removed two instances of trailing whitespaces
To: Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Date: Wed, 18 Jan 2012 14:27:40 -0800
Message-ID: <20120118222740.4079.56984.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
References: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011822-7408-0000-0000-000001FD5DD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove trailing whitespace from lib/crc32.c
	- remove trailing whitespace from lib/crc32defs.h

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c     |    2 +-
 lib/crc32defs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 4b35d2b..ffea0c9 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL(crc32_be);
  * in the correct multiple to subtract, we can shift a byte at a time.
  * This produces a 40-bit (rather than a 33-bit) intermediate remainder,
  * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.  
+ * the high bits, the high 8 bits in this case.
  *
  * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index 9b6773d..f5a5401 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -8,7 +8,7 @@
 
 /* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
 /* For less performance-sensitive, use 4 */
-#ifndef CRC_LE_BITS 
+#ifndef CRC_LE_BITS
 # define CRC_LE_BITS 8
 #endif
 #ifndef CRC_BE_BITS


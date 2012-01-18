Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2ARW3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:29:39 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58934 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2ARW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:29:33 -0500
Subject: [PATCH 09/13] crc32: Add note about this patchset to crc32.c
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
Date: Wed, 18 Jan 2012 14:28:35 -0800
Message-ID: <20120118222835.4079.84248.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
References: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011822-7408-0000-0000-000001FD5F94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some final changes
	- added a comment at the top of crc32.c

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 4eac9c7..a1a5145 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was


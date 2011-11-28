Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1K1WjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:39:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:54361 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1K1WjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:39:02 -0500
Subject: [PATCH 10/14] Some final changes
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
Date: Mon, 28 Nov 2011 14:38:14 -0800
Message-ID: <20111128223814.28705.53865.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
References: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11112822-5518-0000-0000-000000AAA6C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- added a comment at the top of crc32.c

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
---
 lib/crc32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 2c8e8c0..d56516d 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555Ab0GUFSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:18:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0GUEw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bvz6GqXmEvsx6UzAKZ3b5g5pAG6F2Lry4FTbHa7HRZ+j+Yk37larKKUCQLFOS3Py4w
         bVO8hkAbC9LS+oi6+KMSUsf9HNbR2MgLT8qbX6yL1Ob1dEQ3K67NPM9eoLxKo5x6h/vl
         B83hRWC1BT2J5bMGLWJIdL0iF2Sa2iSx9lmQ0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 32/32]Documentation/filesystems/vfat.txt update web address.
Date: Tue, 20 Jul 2010 21:52:49 -0700
Message-Id: <1279687982-29413-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address due to me being unable to
locate. If anybody knows the location let me know and I'll
update this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/vfat.txt |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index eed520f..3d88323 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -160,16 +160,6 @@ If you have trouble with the VFAT filesystem, mail bug reports to
 chaffee@bmrc.cs.berkeley.edu.  Please specify the filename
 and the operation that gave you trouble.
 
-TEST SUITE
-----------------------------------------------------------------------
-If you plan to make any modifications to the vfat filesystem, please
-get the test suite that comes with the vfat distribution at
-
-  http://bmrc.berkeley.edu/people/chaffee/vfat.html
-
-This tests quite a few parts of the vfat filesystem and additional
-tests for new features or untested features would be appreciated.
-
 NOTES ON THE STRUCTURE OF THE VFAT FILESYSTEM
 ----------------------------------------------------------------------
 (This documentation was provided by Galen C. Hunt <gchunt@cs.rochester.edu>
-- 
1.7.1.rc1.21.gf3bd6


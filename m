Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab0IGDnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:43:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44492 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0IGDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k4KKMkjsMzq0437atNT2vi4HAffrQ/EH+wW0ksSr+1dxB4kVX9q94RnKNcjD4WwAs2
         4Tu0VhHK/DgUSnjJAlWUeNGtQ/nFfTUo6TtulFKqU00RVjjoBoltqexUbnZJo+kSGITr
         4C7gWB2C0LbvYS7b2rX10jJx4eVSGTHUQ0hFk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/4] Documentation/filesystems/vfat.txt Fix web address to one line instead of two.
Date: Mon,  6 Sep 2010 20:42:59 -0700
Message-Id: <1283830980-25750-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
References: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in other posts, it's better to just have the web address
as one long line instead of broken into two lines.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/vfat.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index ead764b..db055ed 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -165,8 +165,7 @@ TEST SUITE
 If you plan to make any modifications to the vfat filesystem, please
 get the test suite that comes with the vfat distribution at
 
-  http://web.archive.org/web/*/http://bmrc.berkeley.edu/
-  people/chaffee/vfat.html
+  http://web.archive.org/web/*/http://bmrc.berkeley.edu/people/chaffee/vfat.html
 
 This tests quite a few parts of the vfat filesystem and additional
 tests for new features or untested features would be appreciated.
-- 
1.7.2.1


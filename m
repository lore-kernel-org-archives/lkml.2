Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2EUCta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:49:30 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:38449 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756963Ab2EUCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:49:28 -0400
Message-ID: <4FB9AD3C.3040909@xenotime.net>
Date: Sun, 20 May 2012 19:49:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/3] scripts/patch-kernel: fix typos and compression comment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix typo, drop trailing whitespace, and add "xz" to list of
compression types supported.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 scripts/patch-kernel |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-34-rc7-pk.orig/scripts/patch-kernel
+++ lnx-34-rc7-pk/scripts/patch-kernel
@@ -26,8 +26,8 @@
 #
 #       Nick Holloway <Nick.Holloway@alfie.demon.co.uk>, 2nd January 1995.
 #
-# Added support for handling multiple types of compression. What includes
-# gzip, bzip, bzip2, zip, compress, and plaintext. 
+# Added support for handling multiple types of compression. That includes
+# gzip, bzip, bzip2, zip, compress, xz, and plaintext.
 #
 #       Adam Sulmicki <adam@cfar.umd.edu>, 1st January 1997.
 #
@@ -159,7 +159,7 @@ applyPatch () {
   fi
   # Remove backup files
   find $sourcedir/ '(' -name '*.orig' -o -name '.*.orig' ')' -exec rm -f {} \;
- 
+
   return 0;
 }
 

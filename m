Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2JAXLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:11:05 -0400
Received: from 1wt.eu ([62.212.114.60]:35575 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab2JAXCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:45 -0400
Message-Id: <20121001225204.947226207@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 173/180] MAINTAINERS: Theodore Tso is taking over the random driver
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 330e0a01d54c2b8606c56816f99af6ebc58ec92c upstream.

Matt Mackall stepped down as the /dev/random driver maintainer last
year, so Theodore Ts'o is taking back the /dev/random driver.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 613da5d..334258c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4379,7 +4379,7 @@ F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
-M:	Matt Mackall <mpm@selenic.com>
+M:	Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained
 F:	drivers/char/random.c
 
-- 
1.7.2.1.45.g54fbc




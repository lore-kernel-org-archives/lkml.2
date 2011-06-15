Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab1FOUCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:02:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52380 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1FOUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:02:24 -0400
Date: Wed, 15 Jun 2011 12:58:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>
Subject: [PATCH 2/4] Documentation: update kmemleak supported archs
Message-Id: <20110615125829.c66701db.randy.dunlap@oracle.com>
In-Reply-To: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
References: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DF90FCD.009F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxin B. John <maxin.john@gmail.com>

Instead of listing the architectures that are supported by
kmemleak in Documentation/kmemleak.txt, just refer people to
the list of supported architecutures in lib/Kconfig.debug so
that Documentation/kmemleak.txt does not need more updates
for this.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
---
 Documentation/kmemleak.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-30-rc2.orig/Documentation/kmemleak.txt
+++ lnx-30-rc2/Documentation/kmemleak.txt
@@ -11,7 +11,9 @@ with the difference that the orphan obje
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
+
+Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug for supported
+architectures.
 
 Usage
 -----

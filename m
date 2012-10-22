Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JVMSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2JVMSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:18:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UAPI: Fix up empty files in arch/cris/
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 22 Oct 2012 13:18:44 +0100
Message-ID: <20121022121844.14852.49121.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up three empty files in arch/cris/ by sticking placeholder comments in
there to prevent the patch program from deleting them.

I decided not to delete the arch-v*/Kbuild files as it's possibly someone might
want to use them for genhdr-y lines in the future, but they could be deleted
and the pointer lines removed from asm/Kbuild.  The uapi/arch-v*/Kbuild files
ought to be uneffected by such a change.

asm/swab.h didn't have anything outside of __KERNEL__ so nothing appeared in
uapi/asm/swab.h.  The latter, however, is exported by Kbuild.asm.

This needs to be applied after the CRIS UAPI disintegration patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/cris/include/arch-v10/arch/Kbuild |    1 +
 arch/cris/include/arch-v32/arch/Kbuild |    1 +
 arch/cris/include/uapi/asm/swab.h      |    3 +++
 3 files changed, 5 insertions(+)

diff --git a/arch/cris/include/arch-v10/arch/Kbuild b/arch/cris/include/arch-v10/arch/Kbuild
index e69de29..a286906 100644
--- a/arch/cris/include/arch-v10/arch/Kbuild
+++ b/arch/cris/include/arch-v10/arch/Kbuild
@@ -0,0 +1 @@
+# Cris arch V10
diff --git a/arch/cris/include/arch-v32/arch/Kbuild b/arch/cris/include/arch-v32/arch/Kbuild
index e69de29..17d19f7 100644
--- a/arch/cris/include/arch-v32/arch/Kbuild
+++ b/arch/cris/include/arch-v32/arch/Kbuild
@@ -0,0 +1 @@
+# Cris arch V32
diff --git a/arch/cris/include/uapi/asm/swab.h b/arch/cris/include/uapi/asm/swab.h
index e69de29..4adf1e9 100644
--- a/arch/cris/include/uapi/asm/swab.h
+++ b/arch/cris/include/uapi/asm/swab.h
@@ -0,0 +1,3 @@
+/*
+ * CRIS byte swapping.
+ */


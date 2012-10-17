Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2JQOQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab2JQOQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:16:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/10] UAPI: Place comments in empty arch Kbuilds to make them
 non-empty
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 17 Oct 2012 15:15:58 +0100
Message-ID: <20121017141558.29084.64892.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place comments in:

	arch/mips/include/asm/Kbuild
	arch/tile/include/arch/Kbuild

to make them non-empty so that the patch program doesn't remove them when it
reduces them to nothing.

Possibly they should be just deleted, but it's possible that they'll acquire
generic-y or genhdr-y lines in future, so I'm keeping them around for the
moment.

Note that MIPS will compile happily if the file is deleted instead.  I haven't
tested TILE, but I suspect it will be the same there.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ralf Baechle <ralf@linux-mips.org>
cc: Chris Metcalf <cmetcalf@tilera.com>
---

 arch/mips/include/asm/Kbuild  |    1 +
 arch/tile/include/arch/Kbuild |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index e69de29..533053d 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -0,0 +1 @@
+# MIPS headers
diff --git a/arch/tile/include/arch/Kbuild b/arch/tile/include/arch/Kbuild
index e69de29..3751c9f 100644
--- a/arch/tile/include/arch/Kbuild
+++ b/arch/tile/include/arch/Kbuild
@@ -0,0 +1 @@
+# Tile arch headers


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2JQOQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2JQOQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:16:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/10] UAPI: The tile arch uses the generic ucontext.h file
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 17 Oct 2012 15:16:05 +0100
Message-ID: <20121017141605.29084.34012.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the header-y and generic-y lines for ucontext.h from
arch/tile/include/asm/Kbuild to the uapi/ Kbuild as the asm-generic variant is
used.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chris Metcalf <cmetcalf@tilera.com>
---

 arch/tile/include/asm/Kbuild      |    3 ---
 arch/tile/include/uapi/asm/Kbuild |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index c68808a..6948015 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -1,8 +1,6 @@
 
 header-y += ../arch/
 
-header-y += ucontext.h
-
 generic-y += bug.h
 generic-y += bugs.h
 generic-y += clkdev.h
@@ -37,5 +35,4 @@ generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += types.h
-generic-y += ucontext.h
 generic-y += xor.h
diff --git a/arch/tile/include/uapi/asm/Kbuild b/arch/tile/include/uapi/asm/Kbuild
index 5c6915f..c20db8e 100644
--- a/arch/tile/include/uapi/asm/Kbuild
+++ b/arch/tile/include/uapi/asm/Kbuild
@@ -15,4 +15,7 @@ header-y += siginfo.h
 header-y += signal.h
 header-y += stat.h
 header-y += swab.h
+header-y += ucontext.h
 header-y += unistd.h
+
+generic-y += ucontext.h


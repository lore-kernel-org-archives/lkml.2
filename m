Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab0I0MMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0I0MMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:12:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Default config choice GDBSTUB_TTYSM0 should be
	GDBSTUB_ON_TTYSM0
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 27 Sep 2010 13:12:33 +0100
Message-ID: <20100927121233.14187.3870.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration choice for the port on which the GDB stub listens has a
default of GDBSTUB_TTYSM0, but this should be GDBSTUB_ON_TTYSM0 to match the
option.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
index ff80e86..ce83c74 100644
--- a/arch/mn10300/Kconfig.debug
+++ b/arch/mn10300/Kconfig.debug
@@ -101,7 +101,7 @@ config GDBSTUB_DEBUG_BREAKPOINT
 
 choice
 	prompt "GDB stub port"
-	default GDBSTUB_TTYSM0
+	default GDBSTUB_ON_TTYSM0
 	depends on GDBSTUB
 	help
 	  Select the serial port used for GDB-stub.


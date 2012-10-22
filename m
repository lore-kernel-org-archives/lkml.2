Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2JVMGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab2JVMGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:06:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] x86: Provide a comment in uapi/asm/setup.h
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 22 Oct 2012 13:06:05 +0100
Message-ID: <20121022120605.14413.53444.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
References: <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a comment in the empty uapi/asm/setup.h to make sure that the patch
program doesn't delete it.

However, should some part of asm/hw_setup.h actually be exported here, or,
possibly, should the entire uapi file be removed?  In v3.6, though the file
was marked for export to userspace, it had nothing outside of __KERNEL__.

This needs to be applied on top of the x86 UAPI disintegration patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/uapi/asm/setup.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/uapi/asm/setup.h b/arch/x86/include/uapi/asm/setup.h
index e69de29..68cd293 100644
--- a/arch/x86/include/uapi/asm/setup.h
+++ b/arch/x86/include/uapi/asm/setup.h
@@ -0,0 +1,3 @@
+/*
+ * x86 setup stuff.
+ */


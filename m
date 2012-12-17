Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2LQOto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:49:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2LQOtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:49:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] x86: Provide guards in uapi/asm/hw_breakpoint.h to
 prevent deletion by patch
To: khali@linux-fr.org
From: David Howells <dhowells@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 14:49:25 +0000
Message-ID: <20121217144924.7769.69501.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide reinclusion guards in the empty uapi/asm/hw_breakpoint.h to make sure
that the patch program doesn't delete it.

However, should some part of asm/hw_breakpoint.h actually be exported here,
or, possibly, should the entire uapi file be removed?  In v3.6, though the
file was marked for export to userspace, it had nothing outside of __KERNEL__.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jean Delvare <khali@linux-fr.org>
---

 arch/x86/include/uapi/asm/hw_breakpoint.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/uapi/asm/hw_breakpoint.h b/arch/x86/include/uapi/asm/hw_breakpoint.h
index e69de29..895596b 100644
--- a/arch/x86/include/uapi/asm/hw_breakpoint.h
+++ b/arch/x86/include/uapi/asm/hw_breakpoint.h
@@ -0,0 +1,4 @@
+#ifndef	_UAPI_I386_HW_BREAKPOINT_H
+#define	_UAPI_I386_HW_BREAKPOINT_H
+
+#endif	/* _UAPI_I386_HW_BREAKPOINT_H */


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2LQOtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2LQOtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:49:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] x86: Provide guards in uapi/asm/setup.h to prevent
 deletion by patch
To: khali@linux-fr.org
From: David Howells <dhowells@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 14:49:32 +0000
Message-ID: <20121217144932.7769.91648.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121217144924.7769.69501.stgit@warthog.procyon.org.uk>
References: <20121217144924.7769.69501.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide reinclusion guards in the empty uapi/asm/setup.h to make sure that the
patch program doesn't delete it.

However, should some part of asm/hw_setup.h actually be exported here, or,
possibly, should the entire uapi file be removed?  In v3.6, though the file
was marked for export to userspace, it had nothing outside of __KERNEL__.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jean Delvare <khali@linux-fr.org>
---

 arch/x86/include/uapi/asm/setup.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/uapi/asm/setup.h b/arch/x86/include/uapi/asm/setup.h
index e69de29..96a4d53 100644
--- a/arch/x86/include/uapi/asm/setup.h
+++ b/arch/x86/include/uapi/asm/setup.h
@@ -0,0 +1,4 @@
+#ifndef _UAPI_ASM_X86_SETUP_H
+#define _UAPI_ASM_X86_SETUP_H
+
+#endif /* _UAPI_ASM_X86_SETUP_H */


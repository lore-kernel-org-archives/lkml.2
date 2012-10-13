Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2JMJIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2JMJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:08:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] UAPI: Unexport part of linux/ppp-comp.h
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Date: Sat, 13 Oct 2012 10:08:10 +0100
Message-ID: <20121013090809.28574.46706.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unexport part of linux/ppp-comp.h as userspace can't make use of that bit.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paul Mackerras <paulus@samba.org>
cc: David Miller <davem@davemloft.net>
---

 include/linux/ppp-comp.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ppp-comp.h b/include/linux/ppp-comp.h
index e53ff65..b7dc06f 100644
--- a/include/linux/ppp-comp.h
+++ b/include/linux/ppp-comp.h
@@ -10,6 +10,8 @@
 #ifndef _NET_PPP_COMP_H
 #define _NET_PPP_COMP_H
 
+#ifdef __KERNEL__
+
 struct module;
 
 /*
@@ -98,6 +100,8 @@ struct compressor {
 #define DECOMP_ERROR		-1	/* error detected before decomp. */
 #define DECOMP_FATALERROR	-2	/* error detected after decomp. */
 
+#endif /* __KERNEL__ */
+
 /*
  * CCP codes.
  */


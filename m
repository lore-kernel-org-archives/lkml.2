Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab0JZCx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab0JZCxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/43] MN10300: Add reads[bwl]() and writes[bwl]()
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:53:44 +0100
Message-ID: <20101026025344.23512.31237.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Add reads[bwl]() and writes[bwl]() for MN10300.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/io.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index c1a4119..787255d 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -206,6 +206,19 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 #define iowrite32_rep(p, src, count) \
 	outsl((unsigned long) (p), (src), (count))
 
+#define readsb(p, dst, count) \
+	insb((unsigned long) (p), (dst), (count))
+#define readsw(p, dst, count) \
+	insw((unsigned long) (p), (dst), (count))
+#define readsl(p, dst, count) \
+	insl((unsigned long) (p), (dst), (count))
+
+#define writesb(p, src, count) \
+	outsb((unsigned long) (p), (src), (count))
+#define writesw(p, src, count) \
+	outsw((unsigned long) (p), (src), (count))
+#define writesl(p, src, count) \
+	outsl((unsigned long) (p), (src), (count))
 
 #define IO_SPACE_LIMIT 0xffffffff
 


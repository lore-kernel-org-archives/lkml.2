Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0KDRgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:36:22 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54033 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0KDRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:36:21 -0400
Subject: [PATCH 1/4] net - Add AF_ALG macros
References: <20101104173456.GA1321@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <E1PE3jX-0000M8-FP@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Thu, 04 Nov 2010 12:36:19 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net - Add AF_ALG macros

This patch adds the socket family/level macros for the yet-to-be-born
AF_ALG family.  The AF_ALG family provides the user-space interface
for the kernel crypto API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/socket.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 5146b50..ebc081b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -193,7 +193,8 @@ struct ucred {
 #define AF_PHONET	35	/* Phonet sockets		*/
 #define AF_IEEE802154	36	/* IEEE802154 sockets		*/
 #define AF_CAIF		37	/* CAIF sockets			*/
-#define AF_MAX		38	/* For now.. */
+#define AF_ALG		38	/* Algorithm sockets		*/
+#define AF_MAX		39	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -234,6 +235,7 @@ struct ucred {
 #define PF_PHONET	AF_PHONET
 #define PF_IEEE802154	AF_IEEE802154
 #define PF_CAIF		AF_CAIF
+#define PF_ALG		AF_ALG
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
@@ -307,6 +309,7 @@ struct ucred {
 #define SOL_RDS		276
 #define SOL_IUCV	277
 #define SOL_CAIF	278
+#define SOL_ALG		279
 
 /* IPX options */
 #define IPX_TYPE	1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab0LOA15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:27:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0LOA1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:27:55 -0500
Date: Tue, 14 Dec 2010 16:26:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH] crypto: ghash-clmulni-intel_glue needs err.h
Message-Id: <20101214162641.3e229f12.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing header file:

arch/x86/crypto/ghash-clmulni-intel_glue.c:256: error: implicit declaration of function 'IS_ERR'
arch/x86/crypto/ghash-clmulni-intel_glue.c:257: error: implicit declaration of function 'PTR_ERR'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101214.orig/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ linux-next-20101214/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -10,6 +10,7 @@
  * by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>

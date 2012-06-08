Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129Ab2FHW0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:26:17 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1603 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759313Ab2FHW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:26:14 -0400
Message-ID: <1339194367.30984.18.camel@x61.thuisdomein>
Subject: [PATCH] crypto: s390 - clean up DES code a bit more
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Jun 2012 00:26:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 22:26:09.0990 (UTC) FILETIME=[B4542660:01CD45C5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 98971f8439b1bb9a61682fe24a865ddd25167a6b ("crypto: s390 - cleanup
DES code") should have also removed crypto_des.h. That file is unused
and unneeded since that commit. So let's clean up that file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Ought to be correct.

 arch/s390/crypto/crypto_des.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)
 delete mode 100644 arch/s390/crypto/crypto_des.h

diff --git a/arch/s390/crypto/crypto_des.h b/arch/s390/crypto/crypto_des.h
deleted file mode 100644
index 6210457..0000000
--- a/arch/s390/crypto/crypto_des.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Function for checking keys for the DES and Tripple DES Encryption
- * algorithms.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-#ifndef __CRYPTO_DES_H__
-#define __CRYPTO_DES_H__
-
-extern int crypto_des_check_key(const u8*, unsigned int, u32*);
-
-#endif /*__CRYPTO_DES_H__*/
-- 
1.7.7.6


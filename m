Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0JPN4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:56:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41662 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0JPN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dOMLpaz33woxJv6hlfndkiD30sPSFhTfIhgjgNO7iVW2zoBOH2MotbQRME5xLhrUXL
         Ypmkgg9HgSGt5cMU0GSG/FvOf9FrzVrDR6HOKJdHmrpfBTAhWskD46e/Y32jrGhJDNxZ
         QsDNu5x4k2333ftaTqAkY4B0WWy6z5QMgI3GM=
From: Tracey Dent <tdent48227@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/02] Drivers: crypto: amcc: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:49:23 -0400
Message-Id: <1287236963-1705-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
References: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/crypto/amcc/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/amcc/Makefile b/drivers/crypto/amcc/Makefile
index aa376e8..5c0c62b 100644
--- a/drivers/crypto/amcc/Makefile
+++ b/drivers/crypto/amcc/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += crypto4xx.o
-crypto4xx-objs :=  crypto4xx_core.o crypto4xx_alg.o crypto4xx_sa.o
+crypto4xx-y :=  crypto4xx_core.o crypto4xx_alg.o crypto4xx_sa.o
-- 
1.7.3.1.104.gc752e


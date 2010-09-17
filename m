Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0IQJqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:46:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40879 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0IQJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Y6X8HNFejCbR2e/WtiydNZNaVqG6Vc7zF3QwWAqspBLk2BpWKY3JS4ofkEGPESQ3qV
         qIlXXSrk5ZYrpAkqgUrtFbq0TxaveL6Q/Cr91eckj20tUAm1bWsFb1DuhmbFT9NDMxim
         JghsU5296Kf9qSIO2y1dseXJJEltWae6me/rU=
From: =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>
To: <devel@driverdev.osuosl.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Forest Bond <forest@alittletooquiet.net>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>
Subject: [PATCH] Staging: vt6655: remove unused update_BssList definition
Date: Fri, 17 Sep 2010 11:46:29 +0200
Message-Id: <1284716789-7482-1-git-send-email-caratorn@gmail.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Charles Clément <caratorn@gmail.com>
---
 drivers/staging/vt6655/ttype.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/ttype.h b/drivers/staging/vt6655/ttype.h
index 37c8fba..be223bd 100644
--- a/drivers/staging/vt6655/ttype.h
+++ b/drivers/staging/vt6655/ttype.h
@@ -37,13 +37,6 @@
 #define TxInSleep
 #endif
 
-//2007-0809-01<Add>by MikeLiu
-#ifndef  update_BssList
-#define update_BssList
-#endif
-
-
-
 #ifndef WPA_SM_Transtatus
 #define WPA_SM_Transtatus
 #endif
-- 
1.7.2.3


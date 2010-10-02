Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab0JBQl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:41:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab0JBQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SAXitP7Lj1Bx1XOrHPPYV1b6nJ9OUb1cbXZmloKcTytMcSX4c94nNp1WcIDGMSk0Ua
         sRd5/BgCwV1jOwiXYAkl6S2He+GwfRu82b0br2us2ULE5bnXI3CgoWew8MnxYQOxn/x6
         FJaWcSiV/zSiAN3IZ7xcBUCWDOt0Xy1KYdlGo=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 05/20] Staging: dream: qdsp5: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:54 -0400
Message-Id: <1286037489-28439-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/dream/qdsp5/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/Makefile b/drivers/staging/dream/qdsp5/Makefile
index beedaaf..44ae6b4 100644
--- a/drivers/staging/dream/qdsp5/Makefile
+++ b/drivers/staging/dream/qdsp5/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS=-Idrivers/staging/dream/include
+ccflags-y:=-Idrivers/staging/dream/include
 obj-y += adsp.o
 ifeq ($(CONFIG_MSM_AMSS_VERSION_6350),y)
 obj-y += adsp_info.o
-- 
1.7.3.1.50.g1e633


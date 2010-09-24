Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0IXSSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:18:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51208 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0IXSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uvkDCZqw55HdgezBdyrclKePZpQS9ajkAgONAwNYAuhqP0Mm+232uOUNEcBy00bVGg
         hq6V36NOLPmmihMricFGzok/5/I8Q/gMZvhtNtcSk/ORmhphRzBISXYn+ayqAh8Y9wCt
         R3yzQl9zmTX++sVPQXfNoDsOnbjoYuu0auni8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/21] Staging: dream: qdsp5: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:18 -0400
Message-Id: <1285352314-5939-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/dream/qdsp5/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/Makefile b/drivers/staging/dream/qdsp5/Makefile
index beedaaf..979bbf8 100644
--- a/drivers/staging/dream/qdsp5/Makefile
+++ b/drivers/staging/dream/qdsp5/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS=-Idrivers/staging/dream/include
+ccflags-y=-Idrivers/staging/dream/include
 obj-y += adsp.o
 ifeq ($(CONFIG_MSM_AMSS_VERSION_6350),y)
 obj-y += adsp_info.o
-- 
1.7.3


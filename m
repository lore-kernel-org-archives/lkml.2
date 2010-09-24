Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0IXX2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:28:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab0IXX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b27KByYFDFgCi7JUXYtljZPqImyDBRWMHOPXXLXusPMVwgjl9SrNRSmC3A7UgRHFWB
         Gs1ZgptoIB/1s2f1zCPCkraVqoYzOIMn43KAIg45Ds1mj1E2GHkJdOML+K3zJmqvf5ZL
         07ZvEuHRx6OuzDOrdUUOW+nBYBW+WmG+2m8O8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 05/22] Staging: dream: qdsp5: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:53 -0400
Message-Id: <1285370890-8984-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option
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
1.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0IXX2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:28:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab0IXX2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eoTBS+jbQ0WHDR5Gr6lLh0WNTWMZIc7vf1D1VI44pxngriNR/id4w2b4QIt6ANqWE0
         jjElz4OU+mIshqgMHPaZI6ulSUL1SMck5L6Cd0K0ql6VJ3Gpxt/3w7HVDFpWqabrOGO5
         A851sSV163x/4ZH425MxcBF9rW5iX1JyuXC98=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 04/22] Staging: dream: camera: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:52 -0400
Message-Id: <1285370890-8984-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/dream/camera/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/Makefile b/drivers/staging/dream/camera/Makefile
index db228d7..03711dc 100644
--- a/drivers/staging/dream/camera/Makefile
+++ b/drivers/staging/dream/camera/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS=-Idrivers/staging/dream/include
+ccflags-y:=-Idrivers/staging/dream/include
 obj-$(CONFIG_MT9T013) += mt9t013.o mt9t013_reg.o
 obj-$(CONFIG_MT9D112) += mt9d112.o mt9d112_reg.o
 obj-$(CONFIG_MT9P012) += mt9p012_fox.o mt9p012_reg.o
-- 
1.7.3


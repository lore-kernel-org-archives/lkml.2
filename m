Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0IXSSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:18:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab0IXSSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DhXIQqd7jBBM3hoJW1cZrQZCWbk90jl8vKfXB9EYc3+VbhxvmiWkrGRQoX2rsVzJrX
         3+WooRMTis7Y3CoNcGuf23R0P9CAQYxKKGaFeowAk6njTuUUyw9IlX6JISORd6L6/GE7
         9aZkyYeLxM0HIaJ55ReY9c2UNK2VcpaA9g7C0=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 04/21] Staging: dream: camera: Makefile: cleaned up makefile cflags lines
Date: Fri, 24 Sep 2010 14:18:17 -0400
Message-Id: <1285352314-5939-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/dream/camera/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/Makefile b/drivers/staging/dream/camera/Makefile
index db228d7..5bbd29b 100644
--- a/drivers/staging/dream/camera/Makefile
+++ b/drivers/staging/dream/camera/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS=-Idrivers/staging/dream/include
+ccflags-y=-Idrivers/staging/dream/include
 obj-$(CONFIG_MT9T013) += mt9t013.o mt9t013_reg.o
 obj-$(CONFIG_MT9D112) += mt9d112.o mt9d112_reg.o
 obj-$(CONFIG_MT9P012) += mt9p012_fox.o mt9p012_reg.o
-- 
1.7.3


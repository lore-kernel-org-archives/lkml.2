Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab0IXSXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:23:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49879 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab0IXSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IJWquTDJGfbFcKqDb7bi3gbUVeg+BEdDNKJOUsAZp2ZBwlUnIObsbzb2xKc1LdiS4M
         2TMcWAZX65SLDwPmfAjlVHowRkoaUz5cjB+NxxkGLwtF8jAe0Ws10G7+PEow1tmz8twW
         CQoldt+Ah8QVJ3GLF0Lpag9MIyWOfPCAmaBt4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/21] Staging: dream: Makefile: cleaned up makedile cflag lines
Date: Fri, 24 Sep 2010 14:18:16 -0400
Message-Id: <1285352314-5939-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/dream/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
index fbea0ab..6492523 100644
--- a/drivers/staging/dream/Makefile
+++ b/drivers/staging/dream/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS=-Idrivers/staging/dream/include
+ccflags-y=-Idrivers/staging/dream/include
 obj-$(CONFIG_MSM_ADSP)		+= qdsp5/
 obj-$(CONFIG_MSM_CAMERA)	+= camera/
 obj-$(CONFIG_INPUT_GPIO)	+= gpio_axis.o gpio_event.o gpio_input.o gpio_matrix.o gpio_output.o
-- 
1.7.3


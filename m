Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0JBQmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:42:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0JBQiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H9yYbyzloc3lj6Lq4lr9lnklCh3kjx1L9sIlCCA6zbE15Mz/nCOosQIVqGuftDbt35
         TL5frLm41Y0lWpEBMbpouxbyxSQ571CX75LkQ9IgP+lKCypFbKz5JJqlnh0mRTr6+rVr
         9qqE44s86yLqBld5Hl89BOU/umaJkRPEtep9U=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 04/20] Staging: dream: camera: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:53 -0400
Message-Id: <1286037489-28439-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
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
1.7.3.1.50.g1e633


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab0JBQlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:41:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0JBQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fZXR/RRyg/eTPNC3u4Qv0GW6aa7EhOKDUjh58wbxG/xcHmv293HvumXrPganCAmVDv
         k/ORSvRXbTpcpQURVKt5Q4Of08GjXECxC18c8FyATzwZHTEyAWNNvCAfWa3WJAjSLpjS
         OnJdKN01ypsw2YqqpS7ftt7RNOynd+JhwFU38=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 07/20] Staging: rt2860: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:56 -0400
Message-Id: <1286037489-28439-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rt2860/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rt2860/Makefile b/drivers/staging/rt2860/Makefile
index 23ae07f..d816ddb 100644
--- a/drivers/staging/rt2860/Makefile
+++ b/drivers/staging/rt2860/Makefile
@@ -1,10 +1,10 @@
 obj-$(CONFIG_RT2860)	+= rt2860sta.o
 
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
-EXTRA_CFLAGS += -DRTMP_MAC_PCI -DRTMP_PCI_SUPPORT -DRT2860
-EXTRA_CFLAGS += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3090
-EXTRA_CFLAGS += -DDBG
+ccflags-y := -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
+ccflags-y += -DRTMP_MAC_PCI -DRTMP_PCI_SUPPORT -DRT2860
+ccflags-y += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3090
+ccflags-y += -DDBG
 
 rt2860sta-objs :=	\
 	common/crypt_md5.o	\
-- 
1.7.3.1.50.g1e633


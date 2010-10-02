Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0JBQii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56995 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab0JBQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VPiooemqDf2TgrgHWKdmfwbyFfb2/exVsYtqx6PrPGrZW8kxV8ivq+7hqK2/vGXRcn
         dz2EennRprkcBZGY9wtQ4HfIdnZieRYqNS33uUBtEmj0RgYu6Lkohdulj/okeFBUhqVr
         n7HUgZQnz0L4ZVquyRGlw5NN1pMkOFtaBOqzU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 17/20] Staging: vt6655: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:06 -0400
Message-Id: <1286037489-28439-17-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/vt6655/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 824c971..f7544a6 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,6 +1,6 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -D__NO_VERSION__
-EXTRA_CFLAGS += -DHOSTAP
+ccflags-y := -DLINUX -D__KERNEL__ -D__NO_VERSION__
+ccflags-y += -DHOSTAP
 
 vt6655_stage-y +=	device_main.o \
 	card.o \
-- 
1.7.3.1.50.g1e633


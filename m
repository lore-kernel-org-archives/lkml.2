Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0IXSTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:19:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56978 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0IXSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CBxOOym6pzGfwUN4hlJQmb1Ea35UlkuvAzXxjAQmHze6c4X3JH0TTqkl0Y/tSif5re
         Hw7rUoVy2Vu7YDEcqm+qh4UrpELnbVcSQvcHya+e7ryQ3B0131WAhH6ru9ZiWg8CM5UB
         nqFtzs/ePXiA0M+5wsaVqANv7rlhDolnUOCyk=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 18/21] Staging: vt6655: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:31 -0400
Message-Id: <1285352314-5939-18-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/vt6655/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 824c971..3c5da6f 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,6 +1,6 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -D__NO_VERSION__
-EXTRA_CFLAGS += -DHOSTAP
+ccflags-y += -DLINUX -D__KERNEL__ -D__NO_VERSION__
+ccflags-y += -DHOSTAP
 
 vt6655_stage-y +=	device_main.o \
 	card.o \
-- 
1.7.3


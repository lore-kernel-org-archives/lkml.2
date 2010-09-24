Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0IXX3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:29:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55484 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab0IXX3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NpzvD6AzRoLEhqCipI5wJpIRuF5nC4Iyq9t1qeDuMJesS5YxRBuLdOG4DAIvscgTc0
         Hfisj9sLoM16d6DzvJ77osVTVS5ttDWxTcWImZy/FcQDrAJCHqCieTboXmV/eCPyRgj0
         XFYoPX+vekBkae/4xVP7YwizV4ZMiTVc6yzNk=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 19/22] Staging:  vt6655: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:07 -0400
Message-Id: <1285370890-8984-19-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/vt6655/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 824c971..b7cb1d5 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,6 +1,6 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -D__NO_VERSION__
-EXTRA_CFLAGS += -DHOSTAP
+ccflags-y := -DLINUX -D__KERNEL__ -D__NO_VERSION__
+ccflags-y := -DHOSTAP
 
 vt6655_stage-y +=	device_main.o \
 	card.o \
-- 
1.7.3


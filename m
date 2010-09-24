Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0IXX3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:29:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab0IXX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IalpxBecHVohQ+zk8/GNSdxK+GmJMsUnOFqmRXxQ1gAyZUpwri5LxJclrSI13fKXA/
         915Ej/uZgn9kNmP+yUZvVAuwAHvnd5AJpr1ATUZvyxEG6YwqGYbcxge9Xw7dxnpUjtAE
         +qz0cwxSES6AIeGtld4L1rAVkON2ylEb6OGYE=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 20/22] Staging: vt6656: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:08 -0400
Message-Id: <1285370890-8984-20-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/vt6656/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 582a35197..6a85a0e 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -1,6 +1,6 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
-EXTRA_CFLAGS += -DHOSTAP
+ccflags-y := -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
+ccflags-y := -DHOSTAP
 
 vt6656_stage-y +=	main_usb.o \
 			card.o  \
-- 
1.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab0IXXcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:32:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab0IXX2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X6238pug0D/F7fAm+Svv79PAWS/IeN+w3WbEJCxqz9Lo3jNfaRW1khZ3wFD2G7InB+
         VCFkRicgzMb7JiMbfB5WSRHRSZY8ZTemN3cwaS1ByA5lgA3BsboNlg8YprDG58y9bRHj
         6gBEQ7vSYkJinowbWvtV6Kkpp4lYw/Cbv3vVQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 06/22] Staging: easycap: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:54 -0400
Message-Id: <1285370890-8984-6-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/easycap/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/easycap/Makefile b/drivers/staging/easycap/Makefile
index d93bd6b..d3133f8 100644
--- a/drivers/staging/easycap/Makefile
+++ b/drivers/staging/easycap/Makefile
@@ -5,9 +5,9 @@ easycap-objs	:= easycap_main.o easycap_low.o easycap_sound.o
 easycap-objs	+= easycap_ioctl.o easycap_settings.o
 easycap-objs	+= easycap_testcard.o
 
-EXTRA_CFLAGS += -Wall
+ccflags-y := -Wall
 # Impose all or none of the following:
-EXTRA_CFLAGS += -DEASYCAP_IS_VIDEODEV_CLIENT
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_DEVICE_H
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_FOPS
+ccflags-y := -DEASYCAP_IS_VIDEODEV_CLIENT
+ccflags-y := -DEASYCAP_NEEDS_V4L2_DEVICE_H
+ccflags-y := -DEASYCAP_NEEDS_V4L2_FOPS
 
-- 
1.7.3


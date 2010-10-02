Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab0JBQih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab0JBQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xMZQcuTJxWnc9Dr2IA6yPV80xQyszy5tK9CHHeKmPnseAACufvHZvGp4EsPfZz6CrB
         Ksoph6dxWcbm61RM5WLLy+Fbj+lYXAQxdCK/CNd2IGQVofUQB0Qwv3VdrARepDq6rlU4
         ytGI/PhjrGlDF+gaDA++a4YcXCmQVg8s9kO2M=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 18/20] Staging: vt6656: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:07 -0400
Message-Id: <1286037489-28439-18-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/vt6656/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 582a35197..41ed06b 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -1,6 +1,6 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
-EXTRA_CFLAGS += -DHOSTAP
+ccflags-y := -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
+ccflags-y += -DHOSTAP
 
 vt6656_stage-y +=	main_usb.o \
 			card.o  \
-- 
1.7.3.1.50.g1e633


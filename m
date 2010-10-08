Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0JHACX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0JHACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VShknSSE2knE6hMaWLlUYdUyL1CaZaifwdxnroTpK9J9N870xj57VUkQa3QhX3piQA
         7tUT9x/ATXXmyWL/SmRhW1q9P1YNOdwrt/k7c0ojJrmsC/STAAK+a6G9it2QjzFYI2Nc
         8260UFxizJp8xYbLDUJwvVH0eU0gr8ulcCzvc=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 15/33] Staging: keucr: Makefile: Makefile clean up
Date: Thu,  7 Oct 2010 20:01:35 -0400
Message-Id: <1286496113-11897-15-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.
Also, Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/keucr/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/Makefile b/drivers/staging/keucr/Makefile
index 2a4200f..5c19b7b 100644
--- a/drivers/staging/keucr/Makefile
+++ b/drivers/staging/keucr/Makefile
@@ -1,8 +1,8 @@
-EXTRA_CFLAGS += -Idrivers/scsi
+ccflags-y := -Idrivers/scsi
 
 obj-$(CONFIG_USB_ENESTORAGE)	+= keucr.o
 
-keucr-objs :=			\
+keucr-y :=			\
 		usb.o		\
 		scsiglue.o	\
 		transport.o	\
-- 
1.7.3.1.50.g1e633


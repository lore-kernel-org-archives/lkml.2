Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0JHAII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:08:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab0JHACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ow3qMVc53ScKAGPhiKKOriGe1aPnynudJMI2h3yDCKm2K77WT1IUvWo2ExBJzWqGZq
         rZf4Z6w87mMm5u2a8wSFfcn7fbBn17ZJ7bFfE4EaF2XFnvWRfE7OFf27/3lFbkYtr7qI
         zBiWP44Gy8aFSNjKl0OJnabaNjJx2v4ET7Luc=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 08/33] Staging: easycap: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:28 -0400
Message-Id: <1286496113-11897-8-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/easycap/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/easycap/Makefile b/drivers/staging/easycap/Makefile
index 680f370..8a3d911 100644
--- a/drivers/staging/easycap/Makefile
+++ b/drivers/staging/easycap/Makefile
@@ -1,9 +1,9 @@
 
 obj-$(CONFIG_EASYCAP)	+= easycap.o
 
-easycap-objs	:= easycap_main.o easycap_low.o easycap_sound.o
-easycap-objs	+= easycap_ioctl.o easycap_settings.o
-easycap-objs	+= easycap_testcard.o
+easycap-y	:= easycap_main.o easycap_low.o easycap_sound.o
+easycap-y	+= easycap_ioctl.o easycap_settings.o
+easycap-y	+= easycap_testcard.o
 
 ccflags-y := -Wall
 # Impose all or none of the following:
-- 
1.7.3.1.50.g1e633


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0KFSzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:55:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55795 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0KFSzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cnia29KpO69Ul9qJGGlTkEPfceAb3o/tHG+OTsbgWxf6omFsG0frMfo3c295EWrlI/
         WZJiH2z+ANRKrAAuFtCTFfOxTPh4DZ56gVdK/p1b0Sa1WPTERBqHRLj/8+D1TVipfDtz
         w4Sa9FdrZAM2PLmmrvVzkpz9SaSES4JMjwfA8=
From: Tracey Dent <tdent48227@gmail.com>
To: geoff@infradead.org
Cc: linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [Resend][PATCH] Drivers: ps3: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat,  6 Nov 2010 14:55:35 -0400
Message-Id: <1289069735-2034-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/ps3/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ps3/Makefile b/drivers/ps3/Makefile
index ccea15c..50cb1e1 100644
--- a/drivers/ps3/Makefile
+++ b/drivers/ps3/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_PS3_VUART) += ps3-vuart.o
 obj-$(CONFIG_PS3_PS3AV) += ps3av_mod.o
-ps3av_mod-objs		+= ps3av.o ps3av_cmd.o
+ps3av_mod-y		:= ps3av.o ps3av_cmd.o
 obj-$(CONFIG_PPC_PS3) += sys-manager-core.o
 obj-$(CONFIG_PS3_SYS_MANAGER) += ps3-sys-manager.o
 obj-$(CONFIG_PS3_STORAGE) += ps3stor_lib.o
-- 
1.7.3.2.146.gca209


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0JPDbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:31:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49509 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0JPDbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jqsF8J/+KkgQSrh4ahoWhNvUOS+t+HCXWtoI7nILivl0MR3DxaGQRg6UfdOob/3CYQ
         SRZxhSiqFOCB6UNPemtwU1xeyon9hwYfAl4IdPQFgoGNwx5rZ6xwgAt81IgaU22t33je
         ySahOSesVxZmzEgO/TfWF+n4e0+QmgCDCOeSA=
From: Tracey Dent <tdent48227@gmail.com>
To: geoff@infradead.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Drivers: ps3: Makefile: replace the use of <module>-objs with <module>-y
Date: Fri, 15 Oct 2010 23:30:48 -0400
Message-Id: <1287199848-1902-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
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
1.7.3.1.104.gc752e


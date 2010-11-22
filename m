Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0KVBJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:09:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab0KVBEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BulMgIG2OS8fo4D08+aU9bHC58NaMxesWT8qvoB5f0IbDpfjl3vweq+1mxhNpL5L2K
         s5y6Y8WR0hlvYXG82bQ0tv7orA54PLdX9uRzlBfmOaveMbbTzKyQ9g4Umn6cwWc3DsTd
         kQ7TMuSTTDjyxhIboSP9YsI9mkXVCFcusSZFs=
From: Tracey Dent <tdent48227@gmail.com>
To: davem@davemloft.net
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 09/17] Net: irda: ircomm: Makefile: Remove deprecated kbuild goal defintions
Date: Sun, 21 Nov 2010 20:03:20 -0500
Message-Id: <1290387808-2239-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs
because -objs is deprecated and not mentioned in
Documentation/kbuild/makefiles.txt.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 net/irda/ircomm/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/irda/ircomm/Makefile b/net/irda/ircomm/Makefile
index 4868945..ab23b5b 100644
--- a/net/irda/ircomm/Makefile
+++ b/net/irda/ircomm/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_IRCOMM) += ircomm.o ircomm-tty.o
 
-ircomm-objs := ircomm_core.o ircomm_event.o ircomm_lmp.o ircomm_ttp.o
-ircomm-tty-objs := ircomm_tty.o ircomm_tty_attach.o ircomm_tty_ioctl.o ircomm_param.o
+ircomm-y := ircomm_core.o ircomm_event.o ircomm_lmp.o ircomm_ttp.o
+ircomm-tty-y := ircomm_tty.o ircomm_tty_attach.o ircomm_tty_ioctl.o ircomm_param.o
-- 
1.7.3.2.245.g03276


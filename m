Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0KVBGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:06:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0KVBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lw+j/gPbDPdSs+irwA4A7DqUxrTyzTjf1xU5hfPL6Mfd/u6jp6bidJzh5J7+WV0FuL
         FFqb9m5Rr097Cnj19TAEgMu9Aeq2y51D9Sw3f8apUCYF1HiGy+7PSLcFYTMyue8Pvcgz
         cfK7JtTTiPCK5Jki82EvK001KjcqyCrG/9iY4=
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
Subject: [PATCH 13/17] Net: phonet: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:24 -0500
Message-Id: <1290387808-2239-14-git-send-email-tdent48227@gmail.com>
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
 net/phonet/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/phonet/Makefile b/net/phonet/Makefile
index d62bbba..e10b1b1 100644
--- a/net/phonet/Makefile
+++ b/net/phonet/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_PHONET) += phonet.o pn_pep.o
 
-phonet-objs := \
+phonet-y := \
 	pn_dev.o \
 	pn_netlink.o \
 	socket.o \
@@ -8,4 +8,4 @@ phonet-objs := \
 	sysctl.o \
 	af_phonet.o
 
-pn_pep-objs := pep.o pep-gprs.o
+pn_pep-y := pep.o pep-gprs.o
-- 
1.7.3.2.245.g03276


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0KVBIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:08:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab0KVBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=snPshpXOxsE94awalPfQz9d0EH42iIVwfEaoxE+6QgUSoaM5hSDUEGAO2OLtftcU2d
         CFhoCfNuG7kAt9ri2yK3EjbR7tEmmNjqnugoNRWMdXkIrBRzBqYoLfFvlN3Y3SGjL/Zw
         oJv6mp6TsQpnAk84wJDSyW2MQkxZPlHj9Xqz0=
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
Subject: [PATCH 11/17] Net: irda: irnet: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:22 -0500
Message-Id: <1290387808-2239-12-git-send-email-tdent48227@gmail.com>
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
 net/irda/irnet/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/irda/irnet/Makefile b/net/irda/irnet/Makefile
index b3ee01e..61c365c 100644
--- a/net/irda/irnet/Makefile
+++ b/net/irda/irnet/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_IRNET) += irnet.o
 
-irnet-objs := irnet_ppp.o irnet_irda.o
+irnet-y := irnet_ppp.o irnet_irda.o
-- 
1.7.3.2.245.g03276


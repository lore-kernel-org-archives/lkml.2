Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0KVBHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:07:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0KVBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kB+NPNOFUuIWW2gOYCNfrzcPuN4YEAJSUNKef5DmWPwcR5Iy3THOc5RrAxAkxEw2iT
         Ki3RezuklwiuNGE701ac9ZM8XI2P2aGjc0PtMMTXGhzliXt7HPiRrLSpfXclUjbWBc6C
         3BLie0Qg7HwUFdpg8+ASJ/SgoEL0eI5slvhb0=
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
Subject: [PATCH 12/17] Net: lapb: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:23 -0500
Message-Id: <1290387808-2239-13-git-send-email-tdent48227@gmail.com>
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
 net/lapb/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/lapb/Makefile b/net/lapb/Makefile
index 53f7c90..fff797d 100644
--- a/net/lapb/Makefile
+++ b/net/lapb/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_LAPB) += lapb.o
 
-lapb-objs := lapb_in.o lapb_out.o lapb_subr.o lapb_timer.o lapb_iface.o
+lapb-y := lapb_in.o lapb_out.o lapb_subr.o lapb_timer.o lapb_iface.o
-- 
1.7.3.2.245.g03276


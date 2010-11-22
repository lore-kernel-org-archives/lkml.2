Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0KVBEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:04:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab0KVBEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MawcAEMR3Fy+kA+94lrpUsmjS/8KONGZaZx4lK1Gxiy5fP8MEczl/or/lsBiQ3GSgG
         sKCiQIJQx1tE1Ge4RZ7MWiErCptg7Vv1os1aRbbygVpveYPxpNf93Ke4XwuxUbxSSgwW
         DhRRpWGHY1LRQ3ZuCSwHrid3D1WeSW+1OR9PE=
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
Subject: [PATCH 05/17] Net: dns_resolver: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:16 -0500
Message-Id: <1290387808-2239-6-git-send-email-tdent48227@gmail.com>
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
 net/dns_resolver/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/dns_resolver/Makefile b/net/dns_resolver/Makefile
index c0ef4e7..d5c13c2 100644
--- a/net/dns_resolver/Makefile
+++ b/net/dns_resolver/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_DNS_RESOLVER) += dns_resolver.o
 
-dns_resolver-objs :=  dns_key.o dns_query.o
+dns_resolver-y :=  dns_key.o dns_query.o
-- 
1.7.3.2.245.g03276


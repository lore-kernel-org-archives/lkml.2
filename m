Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0KVBFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:05:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab0KVBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RnBmvjZUa1t2M7RM/kfrr6sKWWaLxJvejgW8KdvP/UCvazeEEdfdGwj+geV5lymIa8
         PcysePSDU//PCv5mlqM6j1t8HwnqMeRc6r3QjjQTv2SR6DQK1ExsBWTwXj99W9PtcGUK
         CZtyh61Vp/W0hjQxL3Oz1++r89oB+p/uWuzlc=
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
Subject: [PATCH 17/17] Net: wanrouter: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:28 -0500
Message-Id: <1290387808-2239-18-git-send-email-tdent48227@gmail.com>
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
 net/wanrouter/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wanrouter/Makefile b/net/wanrouter/Makefile
index 9f188ab..4da14bc 100644
--- a/net/wanrouter/Makefile
+++ b/net/wanrouter/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_WAN_ROUTER) += wanrouter.o
 
-wanrouter-objs :=  wanproc.o wanmain.o
+wanrouter-y :=  wanproc.o wanmain.o
-- 
1.7.3.2.245.g03276


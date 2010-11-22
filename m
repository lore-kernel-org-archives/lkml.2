Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0KVBIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:08:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0KVBEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LwP/u97sF/sucvT0+W7gOkK2G3+5IWUAh3A59dfttZwYo+AzGtkOAbB7CM3jOHhtSO
         t05pEasZyWEEzt6NVwRa7nGbkGUkdwsOoZxkfWLAHdKX4w7ogR//zpqmRNPJIRJKHIPq
         WFmXkqLoXV6hC1ilsxMTHYW/iXF/8l1oarijw=
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
Subject: [PATCH 10/17] Net: irda: irlan: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:21 -0500
Message-Id: <1290387808-2239-11-git-send-email-tdent48227@gmail.com>
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
 net/irda/irlan/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/irda/irlan/Makefile b/net/irda/irlan/Makefile
index 77549bc..94eefbc 100644
--- a/net/irda/irlan/Makefile
+++ b/net/irda/irlan/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_IRLAN) += irlan.o
 
-irlan-objs := irlan_common.o irlan_eth.o irlan_event.o irlan_client.o irlan_provider.o irlan_filter.o irlan_provider_event.o irlan_client_event.o
+irlan-y := irlan_common.o irlan_eth.o irlan_event.o irlan_client.o irlan_provider.o irlan_filter.o irlan_provider_event.o irlan_client_event.o
-- 
1.7.3.2.245.g03276


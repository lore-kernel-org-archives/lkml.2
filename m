Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0KVBGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:06:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab0KVBEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ifYMF7OQXCLtPAFgScxekKYv13Q4XNlalT/DlXXOgiTGsOTjUTBmsvatIUiNG9Zwb3
         eUOI+GeY1OHCUJYiMKOCrFjeraVnFWCgD6pWxWhhXF0HtZJnNDRqZ8G80PCMvxxlisRE
         pM8GnAeTG6xpdKUkx4sx4wz58ZLoDmUdMCNQc=
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
Subject: [PATCH 15/17] Net: rxrpc: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:26 -0500
Message-Id: <1290387808-2239-16-git-send-email-tdent48227@gmail.com>
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
 net/rxrpc/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index c46867c..d1c3429 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Linux kernel RxRPC
 #
 
-af-rxrpc-objs := \
+af-rxrpc-y := \
 	af_rxrpc.o \
 	ar-accept.o \
 	ar-ack.o \
@@ -21,7 +21,7 @@ af-rxrpc-objs := \
 	ar-transport.o
 
 ifeq ($(CONFIG_PROC_FS),y)
-af-rxrpc-objs += ar-proc.o
+af-rxrpc-y += ar-proc.o
 endif
 
 obj-$(CONFIG_AF_RXRPC) += af-rxrpc.o
-- 
1.7.3.2.245.g03276


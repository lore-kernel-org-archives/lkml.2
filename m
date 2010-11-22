Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0KVBEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:04:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0KVBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rx3bODiN9j5a3rqxiVaBp6nshbTv7/Tf+o47ibfbwtFajQytJPhpdpvKstc0lAcrxM
         zkxvg5pd+Ik3otOLi7hJVfUXTofGA68yQifEsVQbSlvX2NrDeIHCsnKunpmTDy/uus46
         FPC5aMWgvhnKBgiAQS15S8U6i/hKKMSyN21yg=
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
Subject: [PATCH 03/17] Net: can: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:14 -0500
Message-Id: <1290387808-2239-4-git-send-email-tdent48227@gmail.com>
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
 net/can/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/Makefile b/net/can/Makefile
index 9cd3c4b..2d3894b 100644
--- a/net/can/Makefile
+++ b/net/can/Makefile
@@ -3,10 +3,10 @@
 #
 
 obj-$(CONFIG_CAN)	+= can.o
-can-objs		:= af_can.o proc.o
+can-y			:= af_can.o proc.o
 
 obj-$(CONFIG_CAN_RAW)	+= can-raw.o
-can-raw-objs		:= raw.o
+can-raw-y		:= raw.o
 
 obj-$(CONFIG_CAN_BCM)	+= can-bcm.o
-can-bcm-objs		:= bcm.o
+can-bcm-y		:= bcm.o
-- 
1.7.3.2.245.g03276


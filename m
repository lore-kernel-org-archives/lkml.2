Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0JHAJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:09:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0JHACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=djNaBzM834bASh220Z4vX6Q8IBq3BsT2m84QdsSwKJpEFN+pRT2a1VuXz9bCSxUf7M
         pf3BancY4B+mqyL6GxyAhJIqy6149VezpNVKzdC6mpHlq65eZJ3sHJa42TZOa43jZf5a
         A/KjUNc6tMqYtPhhoNZKMOOh0uE4lU3UZW2Ls=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/33] Staging: bcm: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:23 -0400
Message-Id: <1286496113-11897-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/bcm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/bcm/Makefile b/drivers/staging/bcm/Makefile
index 3fdec2e..c3ae25a 100644
--- a/drivers/staging/bcm/Makefile
+++ b/drivers/staging/bcm/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_BCM_WIMAX) +=	bcm_wimax.o
 
-bcm_wimax-objs :=  InterfaceDld.o InterfaceIdleMode.o InterfaceInit.o InterfaceRx.o \
+bcm_wimax-y :=  InterfaceDld.o InterfaceIdleMode.o InterfaceInit.o InterfaceRx.o \
 		InterfaceIsr.o InterfaceMisc.o InterfaceTx.o \
 		Arp.o CmHost.o Debug.o IPv6Protocol.o Qos.o Transmit.o\
 		Bcmnet.o DDRInit.o HandleControlPacket.o\
-- 
1.7.3.1.50.g1e633


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0KFS6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:58:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0KFS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KtJWvboPQNoKRolm9pn/QCVCmRZ/ngCFbCbMhjJeYkorp2MV1jhLceinIYr3kWB3jn
         5BBpNt3u0CUvTnXcm5Yu9xta4KFy5VOtnH0QaiWB8pXyO7cojWQ4zfiuLrBkcGZEgcbv
         3vautBt4m2NlyV7NRmPPzitJa5JP1kjVOvp/M=
From: Tracey Dent <tdent48227@gmail.com>
To: ecashin@coraid.com, sage@newdream.net
Cc: yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat,  6 Nov 2010 14:58:38 -0400
Message-Id: <1289069918-2085-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/block/aoe/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/Makefile b/drivers/block/aoe/Makefile
index e76d997..06ea82c 100644
--- a/drivers/block/aoe/Makefile
+++ b/drivers/block/aoe/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-$(CONFIG_ATA_OVER_ETH)	+= aoe.o
-aoe-objs := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
+aoe-y := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
-- 
1.7.3.2.146.gca209


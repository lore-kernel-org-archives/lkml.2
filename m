Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750861Ab0JPEKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:10:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37009 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0JPEKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RnciyBMIGGM4j5IWUj2JITg8RVzk9tgfFLiLvtNsdB2Q93ZnjUEhKebfyVxAM8byIX
         i8sUpJjUPZnIgHNnMgN9rAogE/+7RIOuZI3D25NzSy9Ac6fxZE/a6TM0ohGm9d8SwLXM
         hIsKdPt1ZD4owNhoEaTOYudimHqQ5dH/Fd9HI=
From: Tracey Dent <tdent48227@gmail.com>
To: sage@newdream.net
Cc: ecashin@coraid.com, yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/2] Drivers: block: aoe: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 00:09:41 -0400
Message-Id: <1287202181-2196-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287202181-2196-1-git-send-email-tdent48227@gmail.com>
References: <1287202181-2196-1-git-send-email-tdent48227@gmail.com>
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
1.7.3.1.104.gc752e


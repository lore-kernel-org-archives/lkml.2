Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab0GWP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:59037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760462Ab0GWP3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:33 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+/GWsANjW/xcLBQ4l4crcyXTqotazOm+wENZnZkI
	JXN600Ygk387uU
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 01/11] MAINTAINERS: update viafb entry
Date: Fri, 23 Jul 2010 15:39:16 +0000
Message-Id: <1279899566-4359-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAINTAINERS: update viafb entry

List the files that got recently moved to include/linux.
Add myself as a maintainer and remove Scott as his email address is
no longer valid and he has shown no interest in maintaining viafb.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Harald Welte <laforge@gnumonks.org>
---
 MAINTAINERS |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index db3d0f5..a402bf4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6152,9 +6152,12 @@ F:	drivers/mmc/host/via-sdmmc.c
 
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
 M:	Joseph Chan <JosephChan@via.com.tw>
-M:	Scott Fang <ScottFang@viatech.com.cn>
+M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/via-core.h
+F:	include/linux/via-gpio.h
+F:	include/linux/via_i2c.h
 F:	drivers/video/via/
 
 VIA VELOCITY NETWORK DRIVER
-- 
1.6.3.2


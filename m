Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2KSJts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:49:48 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34970 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KSJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:49:46 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] MAINTAINERS: Add entry for Davinci video drivers
Date: Mon, 19 Nov 2012 15:18:21 +0530
Message-Id: <1353318501-19880-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch adds an entry in MAINTAINERS file for
TI Davinci media drivers.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4b3aa8..9474cb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6619,6 +6619,18 @@ S:	Supported
 F:	arch/arm/mach-davinci
 F:	drivers/i2c/busses/i2c-davinci.c
 
+TI DAVINCI SERIES MEDIA DRIVER
+M:	Manjunath Hadli <manjunath.hadli@ti.com>
+M:	Prabhakar Lad <prabhakar.lad@ti.com>
+L:	linux-media@vger.kernel.org
+L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
+S:	Supported
+F:	drivers/media/platform/davinci/
+F:	include/media/davinci/
+
 SIS 190 ETHERNET DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
-- 
1.7.4.1


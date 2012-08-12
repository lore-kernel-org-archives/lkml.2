Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2HLOxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:53:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33220 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2HLOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:52:45 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-fbdev@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 11/11] MAINTAINERS: add fblog entry
Date: Sun, 12 Aug 2012 16:53:25 +0200
Message-Id: <1344783205-2384-12-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer for the fblog driver to the MAINTAINERS file.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 375b1fd..40a10b54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2895,6 +2895,12 @@ F:	drivers/video/
 F:	include/video/
 F:	include/linux/fb.h
 
+FRAMEBUFFER LOG DRIVER
+M:	David Herrmann <dh.herrmann@googlemail.com>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	drivers/video/console/fblog.c
+
 FREESCALE DMA DRIVER
 M:	Li Yang <leoli@freescale.com>
 M:	Zhang Wei <zw@zh-kernel.org>
-- 
1.7.11.4


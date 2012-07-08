Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2GHV6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:58:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48306 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2GHV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:57:14 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de,
        linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, bonbons@linux-vserver.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 11/11] MAINTAINERS: add fblog entry
Date: Sun,  8 Jul 2012 23:56:54 +0200
Message-Id: <1341784614-2797-12-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer for the fblog driver to the MAINTAINERS file.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae8fe46..249b02a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2854,6 +2854,12 @@ F:	drivers/video/
 F:	include/video/
 F:	include/linux/fb.h
 
+FRAMEBUFFER LOG DRIVER
+M:	David Herrmann <dh.herrmann@googlemail.com>
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+F:	drivers/video/console/fblog.c
+
 FREESCALE DMA DRIVER
 M:	Li Yang <leoli@freescale.com>
 M:	Zhang Wei <zw@zh-kernel.org>
-- 
1.7.11.1


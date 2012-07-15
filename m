Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2GOTHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:07:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44876 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2GOTFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:36 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 11/11] MAINTAINERS: add fblog entry
Date: Sun, 15 Jul 2012 21:04:46 +0200
Message-Id: <1342379086-7583-12-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer for the fblog driver to the MAINTAINERS file.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 719f57f..227d5ca 100644
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
1.7.11.2


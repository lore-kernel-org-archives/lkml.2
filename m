Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0HaJUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:20:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:44143 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0HaJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:20:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] MAINTAINERS: remove isicom
Date: Tue, 31 Aug 2010 11:19:55 +0200
Message-Id: <1283246395-16624-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <4C7CC90C.2030100@suse.cz>
References: <4C7CC90C.2030100@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not maintain isicom anymore...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e24eb2d..8bab6f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3923,12 +3923,6 @@ S:	Maintained
 F:	Documentation/sound/oss/MultiSound
 F:	sound/oss/msnd*
 
-MULTITECH MULTIPORT CARD (ISICOM)
-M:	Jiri Slaby <jirislaby@gmail.com>
-S:	Maintained
-F:	drivers/char/isicom.c
-F:	include/linux/isicom.h
-
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
 M:	Felipe Balbi <felipe.balbi@nokia.com>
 L:	linux-usb@vger.kernel.org
-- 
1.7.2.2



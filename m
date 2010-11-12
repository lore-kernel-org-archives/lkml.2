Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0KLVlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:14 -0500
Received: from kroah.org ([198.145.64.141]:41586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab0KLVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/19] tty: the development tree is now done in git
Date: Fri, 12 Nov 2010 13:40:48 -0800
Message-Id: <1289598066-10112-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So properly mark it as such in the MAINTAINERS file.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..4c43733 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -161,7 +161,7 @@ M:	Greg Kroah-Hartman <gregkh@suse.de>
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Maintained
-T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
 F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h
 
@@ -5910,7 +5910,7 @@ S:	Maintained
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
-T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
 F:	drivers/char/tty_*
 F:	drivers/serial/serial_core.c
 F:	include/linux/serial_core.h
-- 
1.7.1


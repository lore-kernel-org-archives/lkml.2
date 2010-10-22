Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0JVSWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:22:34 -0400
Received: from kroah.org ([198.145.64.141]:41944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543Ab0JVSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:22:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/49] serial: mark the 8250 driver as maintained
Date: Fri, 22 Oct 2010 11:21:12 -0700
Message-Id: <1287771688-14805-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly I have gone insane, so I might as well tell the world about it.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e2e24b5..768236e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -157,9 +157,11 @@ S:	Maintained
 F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
-S:	Orphan
+S:	Maintained
+T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h
 
-- 
1.7.2


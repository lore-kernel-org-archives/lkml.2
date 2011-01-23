Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1AWDuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 22:50:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27925 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1AWDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 22:50:53 -0500
Date: Sat, 22 Jan 2011 19:50:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: [PATCH] docbook: fix broken serial to tty/serial movement
Message-Id: <20110122195003.3fe14002.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix move of drivers/serial/ to drivers/tty/, where it broke
one of the docbook files.

docproc: drivers/serial/serial_core.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/device-drivers.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-2638-rc2.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-2638-rc2/Documentation/DocBook/device-drivers.tmpl
@@ -217,8 +217,8 @@ X!Isound/sound_firmware.c
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
 !Iinclude/linux/serial_core.h
-!Edrivers/serial/serial_core.c
-!Edrivers/serial/8250.c
+!Edrivers/tty/serial/serial_core.c
+!Edrivers/tty/serial/8250.c
   </chapter>
 
   <chapter id="fbdev">


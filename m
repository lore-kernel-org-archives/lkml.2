Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2BBBRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:17:54 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37525 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752686Ab2BBBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:17:52 -0500
Message-ID: <4F29F1D5.4080708@xenotime.net>
Date: Wed, 01 Feb 2012 18:15:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: gregkh@linuxfoundation.org
Subject: [PATCH] docbook: fix fatal errors in device-drivers docbook and add
 DMA Management section
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix 2 fatal errors in the device-drivers docbook.
Also add some missing files from drivers/base/; since several
of these are DMA-related, add a section for DMA Management.

docproc: drivers/base/sys.c: No such file or directory
docproc: drivers/tty/serial/8250.c: No such file or directory

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/DocBook/device-drivers.tmpl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- lnx-33-rc2.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-33-rc2/Documentation/DocBook/device-drivers.tmpl
@@ -102,9 +102,12 @@ X!Iinclude/linux/kobject.h
 !Iinclude/linux/device.h
      </sect1>
      <sect1><title>Device Drivers Base</title>
+!Idrivers/base/init.c
 !Edrivers/base/driver.c
 !Edrivers/base/core.c
+!Edrivers/base/syscore.c
 !Edrivers/base/class.c
+!Idrivers/base/node.c
 !Edrivers/base/firmware_class.c
 !Edrivers/base/transport_class.c
 <!-- Cannot be included, because
@@ -113,7 +116,7 @@ X!Iinclude/linux/kobject.h
      exceed allowed 44 characters maximum
 X!Edrivers/base/attribute_container.c
 -->
-!Edrivers/base/sys.c
+!Edrivers/base/dd.c
 <!--
 X!Edrivers/base/interface.c
 -->
@@ -121,6 +124,11 @@ X!Edrivers/base/interface.c
 !Edrivers/base/platform.c
 !Edrivers/base/bus.c
      </sect1>
+     <sect1><title>Device Drivers DMA Management</title>
+!Edrivers/base/dma-buf.c
+!Edrivers/base/dma-coherent.c
+!Edrivers/base/dma-mapping.c
+     </sect1>
      <sect1><title>Device Drivers Power Management</title>
 !Edrivers/base/power/main.c
      </sect1>
@@ -219,7 +227,7 @@ X!Isound/sound_firmware.c
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
 !Edrivers/tty/serial/serial_core.c
-!Edrivers/tty/serial/8250.c
+!Edrivers/tty/serial/8250/8250.c
   </chapter>
 
   <chapter id="fbdev">

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2AUSFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:05:49 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45516 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751480Ab2AUSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:49 -0500
Message-ID: <4F1B0BF4.9090802@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:16 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/14] docbook: don't use serial_core.h in device-drivers
 book
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning.  This file no longer contains
kernel-doc comments.

Warning(include/linux/serial_core.h): no structured comments found

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/device-drivers.tmpl |    1 -
 1 file changed, 1 deletion(-)

Does MAINTAINERS need to be updated?  It says:
SERIAL DRIVERS
M:	Alan Cox <alan@linux.intel.com>


--- lnx-33-rc1.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-33-rc1/Documentation/DocBook/device-drivers.tmpl
@@ -218,7 +218,6 @@ X!Isound/sound_firmware.c
 
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
-!Iinclude/linux/serial_core.h
 !Edrivers/tty/serial/serial_core.c
 !Edrivers/tty/serial/8250.c
   </chapter>

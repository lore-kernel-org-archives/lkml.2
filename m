Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab2C3Uhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:37 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47077 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761491Ab2C3Uh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:29 -0400
Message-ID: <4F761986.6040709@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rafal Kapela <raf.kapela@gmail.com>
Subject: [PATCH 8/8] Documentation: fix typo in ABI/stable/sysfs-driver-usb-usbtmc
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafal Kapela <raf.kapela@gmail.com>

Documentation:"the the" in ABI/stable/sysfs-driver-usb-usbtmc Documentation misspelling

Signed-off-by: Rafal Kapela <raf.kapela@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 Documentation/ABI/stable/sysfs-driver-usb-usbtmc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33.orig/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
+++ lnx-33/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
@@ -55,7 +55,7 @@ What:		/sys/bus/usb/drivers/usbtmc/devic
 Date:		August 2008
 Contact:	Greg Kroah-Hartman <gregkh@suse.de>
 Description:
-		This file determines if the the transaction of the USB TMC
+		This file determines if the transaction of the USB TMC
 		device is to be automatically aborted if there is any error.
 		For more details about this, please see the document,
 		"Universal Serial Bus Test and Measurement Class Specification

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2AUSEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:47 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50078 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751254Ab2AUSE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:29 -0500
Message-ID: <4F1B0BE0.1010807@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:56 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: [PATCH 7/14] kernel-doc: fix new warning in usb.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning:

Warning(include/linux/usb.h:1251): No description found for parameter 'num_mapped_sgs'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/usb.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-33-rc1.orig/include/linux/usb.h
+++ lnx-33-rc1/include/linux/usb.h
@@ -1073,6 +1073,7 @@ typedef void (*usb_complete_t)(struct ur
  *	which the host controller driver should use in preference to the
  *	transfer_buffer.
  * @sg: scatter gather buffer list
+ * @num_mapped_sgs: (internal) number of mapped sg entries
  * @num_sgs: number of entries in the sg list
  * @transfer_buffer_length: How big is transfer_buffer.  The transfer may
  *	be broken up into chunks according to the current maximum packet

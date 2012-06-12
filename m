Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2FLW6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:58:43 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:60384 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2FLW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:58:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1339541918!8333955!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove check for PCI_SUPPORT_VER1
Date: Tue, 12 Jun 2012 15:58:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206121558.29741.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This symbol is not defined in the kernel. It appears to be left
over from the 2.4 kernel.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    4 ----
 .../comedi/drivers/addi-data/amcc_s5933_58.h       |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
index d70ac8b..95f7dc6 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -22,10 +22,6 @@
 
 #include "../../comedidev.h"
 
-#ifdef PCI_SUPPORT_VER1
-#error     No support for 2.1.55 and older
-#endif
-
 /* written on base0 */
 #define FIFO_ADVANCE_ON_BYTE_2	0x20000000
 
diff --git a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h b/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
index 349e93c..c26c28c 100644
--- a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
+++ b/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
@@ -23,10 +23,6 @@
 #include <linux/pci.h>
 #include "../../comedidev.h"
 
-#ifdef PCI_SUPPORT_VER1
-#error    Sorry, no support for 2.1.55 and older! :-((((
-#endif
-
 /***********Added by sarath for compatibility with APCI3120
 
 *************************/
-- 
1.7.7


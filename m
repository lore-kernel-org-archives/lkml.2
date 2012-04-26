Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2DZR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:56:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:40534 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2DZR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:56:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1335462974!4091197!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFC: nci/lib.c: include header for exported symbol prototype
Date: Thu, 26 Apr 2012 10:56:00 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <lauro.venancio@openbossa.org>, <aloisio.almeida@openbossa.org>,
        <sameo@linux.intel.com>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204261056.01229.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the header to pickup the exported symbol prototype.

Quites the sparse warning:

warning: symbol 'nci_to_errno' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index 6a63e5e..6b7fd26 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -31,6 +31,7 @@
 #include <linux/errno.h>
 
 #include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
 
 /* NCI status codes to Unix errno mapping */
 int nci_to_errno(__u8 code)

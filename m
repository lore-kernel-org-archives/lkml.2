Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1HFAHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab1HFAHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:50 2011
Message-Id: <20110806000250.479195611@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [16/55] USB: pl2303.h: checkpatch cleanups
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 5d78fcb0caf219e2e6c8e486d7e31fec1333ac06 upstream.

Minor whitespace cleanups to make checkpatch happy.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -5,7 +5,7 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- * 
+ *
  */
 
 #define BENQ_VENDOR_ID			0x04a5
@@ -142,5 +142,5 @@
 #define SANWA_PRODUCT_ID	0x0001
 
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
-#define ADLINK_VENDOR_ID        0x0b63
-#define ADLINK_ND6530_PRODUCT_ID       0x6530
+#define ADLINK_VENDOR_ID		0x0b63
+#define ADLINK_ND6530_PRODUCT_ID	0x6530



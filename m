Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1HaLNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:13:04 -0400
Received: from nskntqsrv01p.mx.bigpond.com ([61.9.168.231]:22822 "EHLO
	nskntqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab1HaLNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:13:01 -0400
Date: Wed, 31 Aug 2011 17:22:54 +1000
From: Shaun Kluzek <g0del@bigpond.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB GADGET: u_serial.c: fixed a brace and whitespace coding
 style issue
Message-ID: <20110831072254.GA9706@epione>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authentication-Info: Submitted using SMTP AUTH LOGIN at nskntotgx04p.mx.bigpond.com from [120.147.37.27] using ID g0del at Wed, 31 Aug 2011 07:23:10 +0000
X-SIH-MSG-ID: rhAyE93/TAD0zmZ50TewOwQiyAzmqyN+8Z4QW81lrR0GT0Hdu8bOJJ/3Y9IElp7l1S5MMRCHPWshY7zmXY7QiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shaun Kluzek <g0del@bigpond.com>
---
 drivers/usb/gadget/u_serial.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index a8aa469..b86022f 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -552,11 +552,8 @@ recycle:
 	/* Push from tty to ldisc; without low_latency set this is handled by
 	 * a workqueue, so we won't get callbacks and can hold port_lock
 	 */
-	if (tty && do_push) {
+	if (tty && do_push)
 		tty_flip_buffer_push(tty);
-	}
-
-
 	/* We want our data queue to become empty ASAP, keeping data
 	 * in the tty and ldisc (not here).  If we couldn't push any
 	 * this time around, there may be trouble unless there's an
-- 
1.7.3.4


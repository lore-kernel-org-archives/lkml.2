Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab2CSRRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:17:07 -0400
Received: from 85.52.197.2.static.abi.uni2.es ([85.52.197.2]:45317 "EHLO
	www.manty.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2CSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:17:05 -0400
Date: Mon, 19 Mar 2012 18:17:00 +0100
From: Santiago Garcia Mantinan <manty@debian.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>,
        linux-usb@vger.kernel.org, Dirk De Schepper <ddeschepper@nvtl.com>
Subject: [PATCH] USB: option: re-add
  NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array
Message-ID: <20120319171659.GA27498@www.manty.net>
References: <20120319102154.GA16536@www.manty.net>
 <20120319150801.GC11180@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319150801.GC11180@burratino>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks!  Can we have your sign-off?  See Documentation/SubmittingPatches,
> item 12 "Sign your work", for what this means.

Sure, just thought that for a one liner that gets back to its place this was
not needed, here it goes with full paths on the patch ...



Re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array

Signed-off-by: Santiago Garcia Mantinan <manty@debian.org>

--- a/drivers/usb/serial/option.c	2012-03-19 10:16:31.046565765 +0100
+++ b/drivers/usb/serial/option.c	2012-03-19 10:55:34.348846327 +0100
@@ -538,6 +538,7 @@
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) },
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5) },

-- 
Manty/BestiaTester -> http://manty.net

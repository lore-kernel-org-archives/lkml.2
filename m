Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0G3TFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:05:16 -0400
Received: from kroah.org ([198.145.64.141]:51648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab0G3RSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:05 2010
Message-Id: <20100730171505.738488952@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephane Glondu <steph@glondu.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [067/165] staging: rtl8192su: add USB VID/PID for HWNUm-300
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephane Glondu <steph@glondu.net>

commit 488d3749620779ab2668c0dba2962836e51e3cd6 upstream.

The Hercules Wireless N USB mini (HWNUm-300) uses the RTL8191S chipset
and seems to work with this driver.

Signed-off-by: Stephane Glondu <steph@glondu.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192su/r8192U_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -127,6 +127,8 @@ static struct usb_device_id rtl8192_usb_
 	{USB_DEVICE(0x2001, 0x3301)},
 	/* Zinwell */
 	{USB_DEVICE(0x5a57, 0x0290)},
+	/* Guillemot */
+	{USB_DEVICE(0x06f8, 0xe031)},
 	//92SU
 	{USB_DEVICE(0x0bda, 0x8172)},
 	{}



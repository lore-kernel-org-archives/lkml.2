Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2GRAKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:10:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab2GRAEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuri Khan <yurivkhan@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 26/37] Input: xpad - add Andamiro Pump It Up pad
Date: Tue, 17 Jul 2012 17:03:03 -0700
Message-Id: <20120717232433.541962093@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Khan <yurivkhan@gmail.com>

commit e76b8ee25e034ab601b525abb95cea14aa167ed3 upstream.

I couldn't find the vendor ID in any of the online databases, but this
mat has a Pump It Up logo on the top side of the controller compartment,
and a disclaimer stating that Andamiro will not be liable on the bottom.

Signed-off-by: Yuri Khan <yurivkhan@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -142,6 +142,7 @@ static const struct xpad_device {
 	{ 0x0c12, 0x880a, "Pelican Eclipse PL-2023", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", 0, XTYPE_XBOX },
+	{ 0x0d2f, 0x0002, "Andamiro Pump It Up pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x0e4c, 0x1097, "Radica Gamester Controller", 0, XTYPE_XBOX },
 	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", 0, XTYPE_XBOX },
 	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", 0, XTYPE_XBOX },



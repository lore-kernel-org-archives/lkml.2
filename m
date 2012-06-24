Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab2FXAgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 20:36:43 -0400
Received: from mail.myaccess.ca ([65.87.230.25]:42167 "EHLO
	mail-relay2.accesscomm.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756269Ab2FXAgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 20:36:42 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 20:36:42 EDT
Date: Sat, 23 Jun 2012 18:26:18 -0600
From: Kevin Mack <kevmack@accesscomm.ca>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add Razer Onza USB ID to xpad
Message-ID: <20120624002618.GA23646@darkstar.accesscomm.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ID for the Razer Onza Tournament Edition.


--- linux-3.4.2/drivers/input/joystick/xpad.c.bak	2012-06-09 09:36:33.000000000 -0600
+++ linux-3.4.2/drivers/input/joystick/xpad.c	2012-06-23 18:07:18.000000000 -0600
@@ -165,6 +165,7 @@
 	{ 0x0f0d, 0x0016, "Hori Real Arcade Pro.EX", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0f0d, 0x000d, "Hori Fighting Stick EX2", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
+	{ 0x1689, 0xfd00, "Razer Onza TE", 0, XTYPE_XBOX360 },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
 };
 
@@ -244,6 +245,7 @@
 	XPAD_XBOX360_VENDOR(0x146b),		/* BigBen Interactive Controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harminix Rock Band Guitar and Drums */
 	XPAD_XBOX360_VENDOR(0x0f0d),            /* Hori Controllers */
+	XPAD_XBOX360_VENDOR(0x1689),            /* Razer Controllers */
 	{ }
 };
 

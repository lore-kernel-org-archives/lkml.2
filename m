Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2IDLbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:31:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2IDLbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:31:51 -0400
Date: Tue, 4 Sep 2012 13:31:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Walmsley <paul@booyaka.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] HID: remove Paul Walmsley's copyright from places
 where it shouldn't be
Message-ID: <alpine.LNX.2.00.1209041326420.23857@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Walmsley has implemented dynamic quirk handling back in 2007 through 
commits:

2eb5dc30eb ("USB HID: encapsulate quirk handling into hid-quirks.c")
8222fbe67c ("USB HID: clarify static quirk handling as squirks")
8cef908235 ("USB HID: add support for dynamically-created quirks")
876b9276b9 ("USB HID: add 'quirks' module parameter")

and as such, his copyright rightly belongs to 
drivers/hid/usbhid/hid-quirks.c file.

However when generic HID code has been converted to bus and individual 
quirks separated out to individual drivers on the bus, the copyright has 
been blindly transfered into all the tiny drivers, which actually don't 
contain any of Pauls' copyrighted code.

Remove the copyright from those sub-drivers.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

Paul,

I am sending this out to you as RFC, and am not willing to apply it 
without your explicit Ack.

Thanks.

 drivers/hid/hid-a4tech.c    |    1 -
 drivers/hid/hid-apple.c     |    1 -
 drivers/hid/hid-aureal.c    |    1 -
 drivers/hid/hid-belkin.c    |    1 -
 drivers/hid/hid-cherry.c    |    1 -
 drivers/hid/hid-cypress.c   |    1 -
 drivers/hid/hid-ezkey.c     |    1 -
 drivers/hid/hid-gyration.c  |    1 -
 drivers/hid/hid-ids.h       |    1 -
 drivers/hid/hid-lg.c        |    1 -
 drivers/hid/hid-microsoft.c |    1 -
 drivers/hid/hid-monterey.c  |    1 -
 drivers/hid/hid-petalynx.c  |    1 -
 drivers/hid/hid-samsung.c   |    1 -
 drivers/hid/hid-sony.c      |    1 -
 drivers/hid/hid-sunplus.c   |    1 -
 drivers/hid/hid-wacom.c     |    1 -
 17 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 902d1df..0a23988 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 585344b..06ebdbb 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby <jirislaby@gmail.com>
  */
 
diff --git a/drivers/hid/hid-aureal.c b/drivers/hid/hid-aureal.c
index ba64b04..7968187 100644
--- a/drivers/hid/hid-aureal.c
+++ b/drivers/hid/hid-aureal.c
@@ -9,7 +9,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 #include <linux/device.h>
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index a1a765a..a1a5a12 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 888ece6..af034d3 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 9e43aac..3e159a5 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index ca1163e..6540af2 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index e88b951..4442c30 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -4,7 +4,6 @@
  *  Copyright (c) 1999 Andreas Gal
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  *  Copyright (c) 2006-2008 Jiri Kosina
  */
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0709c00..753f3d6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  */
 
 /*
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index fc37ed6..e6eca2d 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  *  Copyright (c) 2010 Hendrik Iben
  */
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index e5c699b..3acdcfc 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index dedf757..cd3643e 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index f1ea3ff..4c521de 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 3c1fd8a..a5821d3 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  *  Copyright (c) 2010 Don Prince <dhprince.devel@yahoo.co.uk>
  *
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 5cd25bd..7f33ebf 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -4,7 +4,6 @@
  *  Copyright (c) 1999 Andreas Gal
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  *  Copyright (c) 2006-2008 Jiri Kosina
  */
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index d484a00..45b4b06 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
  */
 
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index fe23a1e..a92d116 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -5,7 +5,6 @@
  *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
  *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
  *  Copyright (c) 2006-2007 Jiri Kosina
- *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby <jirislaby@gmail.com>
  *  Copyright (c) 2006 Andrew Zabolotny <zap@homelink.ru>
  *  Copyright (c) 2009 Bastien Nocera <hadess@hadess.net>

-- 
Jiri Kosina
SUSE Labs

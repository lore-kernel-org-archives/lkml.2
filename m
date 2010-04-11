Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0DKJwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 05:52:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45661 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0DKJwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 05:52:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 Apr 2010 11:52:12 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: change license of exported header files to
 MIT license
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jay Fenlason <fenlason@redhat.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       David Moore <david.moore@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <z2g59ad55d31004081307w2211434as3a3889a256f3ce4@mail.gmail.com>
Message-ID: <tkrat.447a38c0ad4dc6d9@s5r6.in-berlin.de>
References: <20100405192651.GA20312@redhat.com>
 <x2ma7f4d8771004052207m50ca8695ud34432ebbc84bcab@mail.gmail.com>
 <z2g59ad55d31004081307w2211434as3a3889a256f3ce4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Among else, this allows projects like libdc1394 to carry copies of the
ABI related header files without them or distributors having to worry
about effects on the project's overall license terms.  Switch to MIT
license as suggested by Kristian.  Also update the year in the
copyright statement according to source history.

Cc: Kristian Høgsberg <krh@bitplanet.net>
Cc: Jay Fenlason <fenlason@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
as discussed on libdc1394-devel, plus added license statement in
firewire-constants.h and copyright datum update

 include/linux/firewire-cdev.h      |   33 +++++++++++++++++------------
 include/linux/firewire-constants.h |   29 +++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 16 deletions(-)

Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -1,21 +1,26 @@
 /*
  * Char device interface.
  *
- * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ * Copyright (C) 2005-2007  Kristian Hoegsberg <krh@bitplanet.net>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
  */
 
 #ifndef _LINUX_FIREWIRE_CDEV_H
Index: b/include/linux/firewire-constants.h
===================================================================
--- a/include/linux/firewire-constants.h
+++ b/include/linux/firewire-constants.h
@@ -1,3 +1,28 @@
+/*
+ * IEEE 1394 constants.
+ *
+ * Copyright (C) 2005-2007  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
 #ifndef _LINUX_FIREWIRE_CONSTANTS_H
 #define _LINUX_FIREWIRE_CONSTANTS_H
 
@@ -21,7 +46,7 @@
 #define EXTCODE_WRAP_ADD		0x6
 #define EXTCODE_VENDOR_DEPENDENT	0x7
 
-/* Juju specific tcodes */
+/* Linux firewire-core (Juju) specific tcodes */
 #define TCODE_LOCK_MASK_SWAP		(0x10 | EXTCODE_MASK_SWAP)
 #define TCODE_LOCK_COMPARE_SWAP		(0x10 | EXTCODE_COMPARE_SWAP)
 #define TCODE_LOCK_FETCH_ADD		(0x10 | EXTCODE_FETCH_ADD)
@@ -36,7 +61,7 @@
 #define RCODE_TYPE_ERROR		0x6
 #define RCODE_ADDRESS_ERROR		0x7
 
-/* Juju specific rcodes */
+/* Linux firewire-core (Juju) specific rcodes */
 #define RCODE_SEND_ERROR		0x10
 #define RCODE_CANCELLED			0x11
 #define RCODE_BUSY			0x12


-- 
Stefan Richter
-=====-==-=- -=-- -=-==
http://arcgraph.de/sr/


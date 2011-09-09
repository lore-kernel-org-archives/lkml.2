Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1IIOKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:10:51 -0400
Received: from mail.infrascan.de ([188.40.84.136]:60572 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1IIOKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:10:50 -0400
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
To: mina86@mina86.com, balbi@ti.com, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Subject: [PATCH v2] usb gadget: clean up files
Date: Fri,  9 Sep 2011 16:10:44 +0200
Message-Id: <1315577444-13511-1-git-send-email-schwarzkopf@sensortherm.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315572737-11991-1-git-send-email-schwarzkopf@sensortherm.de>
References: <1315572737-11991-1-git-send-email-schwarzkopf@sensortherm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the following two paragraphs:

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc.,59
Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
---
 drivers/usb/gadget/amd5536udc.c     |    9 ---------
 drivers/usb/gadget/amd5536udc.h     |    9 ---------
 drivers/usb/gadget/at91_udc.c       |   10 ----------
 drivers/usb/gadget/at91_udc.h       |   10 ----------
 drivers/usb/gadget/cdc2.c           |    9 ---------
 drivers/usb/gadget/ci13xxx_msm.c    |   11 -----------
 drivers/usb/gadget/composite.c      |    9 ---------
 drivers/usb/gadget/config.c         |    9 ---------
 drivers/usb/gadget/dbgp.c           |    1 -
 drivers/usb/gadget/dummy_hcd.c      |    9 ---------
 drivers/usb/gadget/epautoconf.c     |   10 ----------
 drivers/usb/gadget/ether.c          |    9 ---------
 drivers/usb/gadget/f_ecm.c          |    9 ---------
 drivers/usb/gadget/f_eem.c          |    9 ---------
 drivers/usb/gadget/f_fs.c           |    9 ---------
 drivers/usb/gadget/f_hid.c          |    9 ---------
 drivers/usb/gadget/f_loopback.c     |    9 ---------
 drivers/usb/gadget/f_ncm.c          |    9 ---------
 drivers/usb/gadget/f_obex.c         |    9 ---------
 drivers/usb/gadget/f_phonet.c       |   10 ----------
 drivers/usb/gadget/f_rndis.c        |    9 ---------
 drivers/usb/gadget/f_sourcesink.c   |    9 ---------
 drivers/usb/gadget/f_subset.c       |    9 ---------
 drivers/usb/gadget/f_uvc.c          |    1 -
 drivers/usb/gadget/f_uvc.h          |    1 -
 drivers/usb/gadget/fusb300_udc.c    |   10 ----------
 drivers/usb/gadget/fusb300_udc.h    |   10 ----------
 drivers/usb/gadget/g_ffs.c          |    9 ---------
 drivers/usb/gadget/hid.c            |    9 ---------
 drivers/usb/gadget/imx_udc.h        |    5 -----
 drivers/usb/gadget/inode.c          |    9 ---------
 drivers/usb/gadget/langwell_udc.c   |   10 ----------
 drivers/usb/gadget/langwell_udc.h   |   10 ----------
 drivers/usb/gadget/m66592-udc.c     |   10 ----------
 drivers/usb/gadget/m66592-udc.h     |   10 ----------
 drivers/usb/gadget/mass_storage.c   |    9 ---------
 drivers/usb/gadget/multi.c          |    9 ---------
 drivers/usb/gadget/ncm.c            |    9 ---------
 drivers/usb/gadget/ndis.h           |    6 ------
 drivers/usb/gadget/net2280.c        |    9 ---------
 drivers/usb/gadget/net2280.h        |    9 ---------
 drivers/usb/gadget/omap_udc.c       |    9 ---------
 drivers/usb/gadget/pch_udc.c        |    9 ---------
 drivers/usb/gadget/printer.c        |    9 ---------
 drivers/usb/gadget/pxa25x_udc.c     |   10 ----------
 drivers/usb/gadget/pxa25x_udc.h     |    9 ---------
 drivers/usb/gadget/pxa27x_udc.c     |   10 ----------
 drivers/usb/gadget/pxa27x_udc.h     |    9 ---------
 drivers/usb/gadget/r8a66597-udc.c   |   10 ----------
 drivers/usb/gadget/r8a66597-udc.h   |   10 ----------
 drivers/usb/gadget/s3c2410_udc.c    |   10 ----------
 drivers/usb/gadget/s3c2410_udc.h    |   10 ----------
 drivers/usb/gadget/storage_common.c |    9 ---------
 drivers/usb/gadget/u_ether.c        |    9 ---------
 drivers/usb/gadget/u_ether.h        |    9 ---------
 drivers/usb/gadget/uvc.h            |    1 -
 drivers/usb/gadget/uvc_queue.c      |    1 -
 drivers/usb/gadget/uvc_v4l2.c       |    1 -
 drivers/usb/gadget/uvc_video.c      |    1 -
 drivers/usb/gadget/webcam.c         |    2 +-
 drivers/usb/gadget/zero.c           |    9 ---------
 61 files changed, 1 insertions(+), 496 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 95e8138..50c7c3f 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /*
diff --git a/drivers/usb/gadget/amd5536udc.h b/drivers/usb/gadget/amd5536udc.h
index 1d1c754..f87e29c 100644
--- a/drivers/usb/gadget/amd5536udc.h
+++ b/drivers/usb/gadget/amd5536udc.h
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef AMD5536UDC_H
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index f4690ff..8daa691 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -9,16 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA  02111-1307, USA.
  */
 
 #undef	VERBOSE_DEBUG
diff --git a/drivers/usb/gadget/at91_udc.h b/drivers/usb/gadget/at91_udc.h
index 108ca54..3c0315b 100644
--- a/drivers/usb/gadget/at91_udc.h
+++ b/drivers/usb/gadget/at91_udc.h
@@ -7,16 +7,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
 #ifndef AT91_UDC_H
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 2720ab0..12fca34 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/ci13xxx_msm.c b/drivers/usb/gadget/ci13xxx_msm.c
index 139ac94..d62190d 100644
--- a/drivers/usb/gadget/ci13xxx_msm.c
+++ b/drivers/usb/gadget/ci13xxx_msm.c
@@ -3,17 +3,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
  * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 5cbb1a4..bd95b58 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -7,15 +7,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index 09084fd..a584643 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -7,15 +7,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/errno.h>
diff --git a/drivers/usb/gadget/dbgp.c b/drivers/usb/gadget/dbgp.c
index dbe92ee..715d284 100644
--- a/drivers/usb/gadget/dbgp.c
+++ b/drivers/usb/gadget/dbgp.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2010 Stephane Duverger
  *
  * Released under the GPLv2.
- *
  */
 
 /* verbose messages */
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index d3dcabc..726e830 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -10,15 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 9b7360f..613aad5 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -7,16 +7,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 1690c9d..9e042fc 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 544257a..cd43561 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index b3c3042..6bbf45f 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 19fffcc..fb47f25 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -12,15 +12,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 598e7e2..815c435 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -7,15 +7,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index b37960f..36a860b 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index 86902a6..aa04c72 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -13,15 +13,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index 8f8c643..5f76820 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -10,15 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index 5e14950..6eded28 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
  */
 
 #include <linux/slab.h>
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index fa12ec8..c161074 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -11,15 +11,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index e403a53..91563c7 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index 8675ca4..a8ce238 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/slab.h>
diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index be446b7..ce0060d 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/f_uvc.h b/drivers/usb/gadget/f_uvc.h
index e18a663..abf8329 100644
--- a/drivers/usb/gadget/f_uvc.h
+++ b/drivers/usb/gadget/f_uvc.h
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #ifndef _F_UVC_H_
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 763d462..da9cde4 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
diff --git a/drivers/usb/gadget/fusb300_udc.h b/drivers/usb/gadget/fusb300_udc.h
index f51aa2e..92745bd 100644
--- a/drivers/usb/gadget/fusb300_udc.h
+++ b/drivers/usb/gadget/fusb300_udc.h
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index ebf6970..dced765 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #define pr_fmt(fmt) "g_ffs: " fmt
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 2523e54..5a9f46d 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/imx_udc.h b/drivers/usb/gadget/imx_udc.h
index 7136c24..d118fb7 100644
--- a/drivers/usb/gadget/imx_udc.h
+++ b/drivers/usb/gadget/imx_udc.h
@@ -8,11 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
- *	This program is distributed in the hope that it will be useful,
- *	but WITHOUT ANY WARRANTY; without even the implied warranty of
- *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *	GNU General Public License for more details.
  */
 
 #ifndef __LINUX_USB_GADGET_IMX_H
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a56876a..bd37257 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 9cee88a..709db38 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -5,16 +5,6 @@
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
  */
 
 
diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
index f1d9c1b..1bec66f 100644
--- a/drivers/usb/gadget/langwell_udc.h
+++ b/drivers/usb/gadget/langwell_udc.h
@@ -5,16 +5,6 @@
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
  */
 
 #include <linux/usb/langwell_udc.h>
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 084aa08..f8f8d3b 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/usb/gadget/m66592-udc.h b/drivers/usb/gadget/m66592-udc.h
index c3caf1a..3a610a0 100644
--- a/drivers/usb/gadget/m66592-udc.h
+++ b/drivers/usb/gadget/m66592-udc.h
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #ifndef __M66592_UDC_H__
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 0182242..86db21c 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -10,15 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index d9feced..82c0ec3 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -10,15 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/ncm.c b/drivers/usb/gadget/ncm.c
index 99c179a..7805afd 100644
--- a/drivers/usb/gadget/ncm.c
+++ b/drivers/usb/gadget/ncm.c
@@ -14,15 +14,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define DEBUG */
diff --git a/drivers/usb/gadget/ndis.h b/drivers/usb/gadget/ndis.h
index df886ce..b0e52fc 100644
--- a/drivers/usb/gadget/ndis.h
+++ b/drivers/usb/gadget/ndis.h
@@ -10,12 +10,6 @@
  *
  * This source code is offered for use in the public domain. You may
  * use, modify or distribute it freely.
- *
- * This code is distributed in the hope that it will be useful but
- * WITHOUT ANY WARRANTY. ALL WARRANTIES, EXPRESS OR IMPLIED ARE HEREBY
- * DISCLAIMED. This includes but is not limited to warranties of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #ifndef _LINUX_NDIS_H
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 476d88e..65e3aed 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -33,15 +33,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #undef	DEBUG		/* messages on error and most fault paths */
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index c368522..a844be0 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -11,15 +11,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/usb/net2280.h>
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 82fd249..00dd224 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -10,15 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #undef	DEBUG
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 68dbcc3..9998a71 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -4,15 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 271ef94..8e6b2c6 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/module.h>
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index 7745454..ffc56c7 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -11,16 +11,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
index f572c56..4634cd3 100644
--- a/drivers/usb/gadget/pxa25x_udc.h
+++ b/drivers/usb/gadget/pxa25x_udc.h
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef __LINUX_USB_GADGET_PXA25X_H
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 5760769..2f283db 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -8,16 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/pxa27x_udc.h b/drivers/usb/gadget/pxa27x_udc.h
index cd16231..2b7db3b 100644
--- a/drivers/usb/gadget/pxa27x_udc.h
+++ b/drivers/usb/gadget/pxa27x_udc.h
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307	 USA
  */
 
 #ifndef __LINUX_USB_GADGET_PXA27X_H
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 6dcc1f6..c0b948a 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/usb/gadget/r8a66597-udc.h b/drivers/usb/gadget/r8a66597-udc.h
index 5fc22e0..d0eea16 100644
--- a/drivers/usb/gadget/r8a66597-udc.h
+++ b/drivers/usb/gadget/r8a66597-udc.h
@@ -8,16 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #ifndef __R8A66597_H__
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 100f263..4ad6a12 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -10,16 +10,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/usb/gadget/s3c2410_udc.h b/drivers/usb/gadget/s3c2410_udc.h
index 9e0bece..a48f619 100644
--- a/drivers/usb/gadget/s3c2410_udc.h
+++ b/drivers/usb/gadget/s3c2410_udc.h
@@ -9,16 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 #ifndef _S3C2410_UDC_H
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 1fa4f70..94ac002 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 2ac1d21..4f41c14 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /* #define VERBOSE_DEBUG */
diff --git a/drivers/usb/gadget/u_ether.h b/drivers/usb/gadget/u_ether.h
index b56e1e7..05b36c2 100644
--- a/drivers/usb/gadget/u_ether.h
+++ b/drivers/usb/gadget/u_ether.h
@@ -9,15 +9,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef __U_ETHER_H
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index 5b79194..b80d514 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #ifndef _UVC_GADGET_H_
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index f7395ac..dc56414 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index 5e807f0..6bc4ba6 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
index b08f354..b0e53a8 100644
--- a/drivers/usb/gadget/uvc_video.c
+++ b/drivers/usb/gadget/uvc_video.c
@@ -8,7 +8,6 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index a5a0fdb..1a748db 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -8,8 +8,8 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- *
  */
+
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/usb/video.h>
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 6d16db9..8957c19 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -8,15 +8,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 
-- 
1.7.0.4


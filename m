Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0EXPu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:50:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47871 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab0EXPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:50:21 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Henry Zhao <Henry.Zhao@Sun.COM>,
       <dri-devel@lists.freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH resent twice 2/3] vgaarb: use MIT license
Date: Mon, 24 May 2010 18:24:31 +0300
Message-Id: <1274714671-7009-2-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1274714671-7009-1-git-send-email-tiago.vignatti@nokia.com>
References: <1274714671-7009-1-git-send-email-tiago.vignatti@nokia.com>
X-OriginalArrivalTime: 24 May 2010 15:49:59.0184 (UTC) FILETIME=[C3A98100:01CAFB58]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Henry Zhao <Henry.Zhao@Sun.COM>
---
Jesse and Dave, that was send two times already and no one said anything.
Please, pull it. Oracle's Henry Zhao is already employing it in Solaris and,
after all authors agreed, we haven't changed yet the license.


 drivers/gpu/vga/vgaarb.c |   26 +++++++++++++++++++++++---
 include/linux/vgaarb.h   |   21 +++++++++++++++++++++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 290b0cc..b87569e 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1,12 +1,32 @@
 /*
- * vgaarb.c
+ * vgaarb.c: Implements the VGA arbitration. For details refer to
+ * Documentation/vgaarbiter.txt
+ *
  *
  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
  *
- * Implements the VGA arbitration. For details refer to
- * Documentation/vgaarbiter.txt
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS
+ * IN THE SOFTWARE.
+ *
  */
 
 #include <linux/module.h>
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 2dfaa29..c9a9759 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -5,6 +5,27 @@
  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS
+ * IN THE SOFTWARE.
+ *
  */
 
 #ifndef LINUX_VGA_H
-- 
1.6.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab0JFBHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:07:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38870 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab0JFBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n++Zn3Be04X7SnrAzHNmxA8LI9ZWVzW+sMSl/BBVXkHGmu0B7NB5wCGjTZ4vTi4D3H
         x+9Sn8+hLWOEukEBNQCEZX0jDygqy/wXWChZyyNWsoKEyLjA/wlxlQ+eqxqKYJE1HUkB
         XUpCXo0/TSn35jUU5Nh/Nj73aFEBzrc8iFnNM=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/28] Staging: comedi: comedi_compat32.h: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:18 -0400
Message-Id: <1286326843-6170-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. All warnings were
WARNING: please, no space for starting a line.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/comedi_compat32.h |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.h b/drivers/staging/comedi/comedi_compat32.h
index 0340a89..77f4216 100644
--- a/drivers/staging/comedi/comedi_compat32.h
+++ b/drivers/staging/comedi/comedi_compat32.h
@@ -1,26 +1,26 @@
 /*
-    comedi/comedi_compat32.h
-    32-bit ioctl compatibility for 64-bit comedi kernel module.
+	comedi/comedi_compat32.h
+	32-bit ioctl compatibility for 64-bit comedi kernel module.
 
-    Author: Ian Abbott, MEV Ltd. <abbotti@mev.co.uk>
-    Copyright (C) 2007 MEV Ltd. <http://www.mev.co.uk/>
+	Author: Ian Abbott, MEV Ltd. <abbotti@mev.co.uk>
+	Copyright (C) 2007 MEV Ltd. <http://www.mev.co.uk/>
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1997-2007 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 1997-2007 David A. Schleef <ds@schleef.org>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
 
-- 
1.7.3.1.50.g1e633


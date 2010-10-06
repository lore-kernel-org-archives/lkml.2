Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0JFBBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab0JFBBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u8F1n1JRuL4rfCiSylKj1ZPJOcwljg0Ml/1sbZUvvLoOQ/Jmse9MojIhiWybJolEXF
         p227rT+eANxWLegBD73u18xAAAycfC6Vz30IAHZNnofPHaozW/0i0wN7ZPYpJWieyyZ7
         OpZHTH/Vsfy4Gyx//J06J8naiA2mxWgzoc0Qk=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 13/28] Staging: comedi: drivers: 8255.h: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:28 -0400
Message-Id: <1286326843-6170-13-git-send-email-tdent48227@gmail.com>
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
 drivers/staging/comedi/drivers/8255.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.h b/drivers/staging/comedi/drivers/8255.h
index b6314c9..80e60c5 100644
--- a/drivers/staging/comedi/drivers/8255.h
+++ b/drivers/staging/comedi/drivers/8255.h
@@ -1,23 +1,23 @@
 /*
-    module/8255.h
-    Header file for 8255
+	module/8255.h
+	Header file for 8255
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1998 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 1998 David A. Schleef <ds@schleef.org>
 
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


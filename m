Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0KSWVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:21:13 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:58614 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab0KSV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:55 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 9/9] sisfb: delete osdef.h
Date: Fri, 19 Nov 2010 23:58:51 +0200
Message-Id: <1290203931-25188-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file is not needed.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.h       |    1 -
 drivers/video/sis/init301.h    |    1 -
 drivers/video/sis/initextlfb.c |    1 -
 drivers/video/sis/osdef.h      |   61 ----------------------------------------
 drivers/video/sis/sis.h        |    1 -
 5 files changed, 0 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/video/sis/osdef.h

diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index 79aec28..ee8ed3c 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -53,7 +53,6 @@
 #ifndef _INIT_H_
 #define _INIT_H_
 
-#include "osdef.h"
 #include "initdef.h"
 
 #include "vgatypes.h"
diff --git a/drivers/video/sis/init301.h b/drivers/video/sis/init301.h
index 2677152..e1fd31d 100644
--- a/drivers/video/sis/init301.h
+++ b/drivers/video/sis/init301.h
@@ -53,7 +53,6 @@
 #ifndef  _INIT301_H_
 #define  _INIT301_H_
 
-#include "osdef.h"
 #include "initdef.h"
 
 #include "vgatypes.h"
diff --git a/drivers/video/sis/initextlfb.c b/drivers/video/sis/initextlfb.c
index 1975308..9dec64d 100644
--- a/drivers/video/sis/initextlfb.c
+++ b/drivers/video/sis/initextlfb.c
@@ -25,7 +25,6 @@
  * Author:	Thomas Winischhofer <thomas@winischhofer.net>
  */
 
-#include "osdef.h"
 #include "initdef.h"
 #include "vgatypes.h"
 #include "vstruct.h"
diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
deleted file mode 100644
index 5baaa79..0000000
--- a/drivers/video/sis/osdef.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/* $XFree86$ */
-/* $XdotOrg$ */
-/*
- * OS depending defines
- *
- * Copyright (C) 2001-2005 by Thomas Winischhofer, Vienna, Austria
- *
- * If distributed as part of the Linux kernel, the following license terms
- * apply:
- *
- * * This program is free software; you can redistribute it and/or modify
- * * it under the terms of the GNU General Public License as published by
- * * the Free Software Foundation; either version 2 of the named License,
- * * or any later version.
- * *
- * * This program is distributed in the hope that it will be useful,
- * * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * * GNU General Public License for more details.
- * *
- * * You should have received a copy of the GNU General Public License
- * * along with this program; if not, write to the Free Software
- * * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
- *
- * Otherwise, the following license terms apply:
- *
- * * Redistribution and use in source and binary forms, with or without
- * * modification, are permitted provided that the following conditions
- * * are met:
- * * 1) Redistributions of source code must retain the above copyright
- * *    notice, this list of conditions and the following disclaimer.
- * * 2) Redistributions in binary form must reproduce the above copyright
- * *    notice, this list of conditions and the following disclaimer in the
- * *    documentation and/or other materials provided with the distribution.
- * * 3) The name of the author may not be used to endorse or promote products
- * *    derived from this software without specific prior written permission.
- * *
- * * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
- * * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
- * * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
- * * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- * * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- * * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- * * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- * Author: 	Thomas Winischhofer <thomas@winischhofer.net>
- *		Silicon Integrated Systems, Inc. (used by permission)
- *
- */
-
-#ifndef _SIS_OSDEF_H_
-#define _SIS_OSDEF_H_
-
-/**********************************************************************/
-/*  LINUX KERNEL                                                      */
-/**********************************************************************/
-
-#endif  /* _OSDEF_H_ */
diff --git a/drivers/video/sis/sis.h b/drivers/video/sis/sis.h
index 7c5710e..80d89d3 100644
--- a/drivers/video/sis/sis.h
+++ b/drivers/video/sis/sis.h
@@ -24,7 +24,6 @@
 #ifndef _SIS_H_
 #define _SIS_H_
 
-#include "osdef.h"
 #include <video/sisfb.h>
 
 #include "vgatypes.h"
-- 
1.5.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1GORaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:30:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33380
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752251Ab1GORaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 104/117] Staging: hv: storvsc: Cleanup storvsc_drv.c after adding the contents of hyperv_storage.h
Date: Fri, 15 Jul 2011 10:47:32 -0700
Message-Id: <1310752065-27895-104-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc_drv.c after adding the contents of hyperv_storage.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 463b428..02f9c1e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -22,6 +22,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/completion.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -42,32 +43,6 @@
 #include "hyperv.h"
 
 
-/*
- *
- * Copyright (c) 2011, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *   K. Y. Srinivasan <kys@microsoft.com>
- *
- */
-
-
-
 /* vstorage.w revision number.  This is used in the case of a version match, */
 /* to alert the user that structure sizes may be mismatched even though the */
 /* protocol versions match. */
@@ -240,9 +215,6 @@ struct vstor_packet {
 #define VSC_LEGAL_FLAGS		(REQUEST_COMPLETION_FLAG)
 
 
-#include <linux/kernel.h>
-#include <linux/wait.h>
-#include "hyperv.h"
 
 /* Defines */
 #define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
-- 
1.7.4.1


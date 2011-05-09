Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1EJIrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:47:25 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35452
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756029Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 195/206] Staging: hv: Get rid of rndis_filter.h
Date: Mon,  9 May 2011 14:57:57 -0700
Message-Id: <1304978288-22999-195-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of rndis_filter.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.h |   55 -------------------------------------
 1 files changed, 0 insertions(+), 55 deletions(-)
 delete mode 100644 drivers/staging/hv/rndis_filter.h

diff --git a/drivers/staging/hv/rndis_filter.h b/drivers/staging/hv/rndis_filter.h
deleted file mode 100644
index 4da18f3..0000000
--- a/drivers/staging/hv/rndis_filter.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
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
- *
- */
-
-
-#ifndef _RNDISFILTER_H_
-#define _RNDISFILTER_H_
-
-#define __struct_bcount(x)
-
-#include "netvsc.h"
-
-#include "rndis.h"
-
-#define RNDIS_HEADER_SIZE	(sizeof(struct rndis_message) - \
-				 sizeof(union rndis_message_container))
-
-#define NDIS_PACKET_TYPE_DIRECTED	0x00000001
-#define NDIS_PACKET_TYPE_MULTICAST	0x00000002
-#define NDIS_PACKET_TYPE_ALL_MULTICAST	0x00000004
-#define NDIS_PACKET_TYPE_BROADCAST	0x00000008
-#define NDIS_PACKET_TYPE_SOURCE_ROUTING	0x00000010
-#define NDIS_PACKET_TYPE_PROMISCUOUS	0x00000020
-#define NDIS_PACKET_TYPE_SMT		0x00000040
-#define NDIS_PACKET_TYPE_ALL_LOCAL	0x00000080
-#define NDIS_PACKET_TYPE_GROUP		0x00000100
-#define NDIS_PACKET_TYPE_ALL_FUNCTIONAL	0x00000200
-#define NDIS_PACKET_TYPE_FUNCTIONAL	0x00000400
-#define NDIS_PACKET_TYPE_MAC_FRAME	0x00000800
-
-
-/* Interface */
-
-extern int rndis_filter_init(struct netvsc_driver *driver);
-
-#endif /* _RNDISFILTER_H_ */
-- 
1.7.4.1


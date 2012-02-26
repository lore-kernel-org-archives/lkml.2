Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2BZCTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 21:19:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33993 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2BZCTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 21:19:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.236.192.230 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
Date: Sat, 25 Feb 2012 23:19:11 -0300
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        jarod@wilsonet.com, nsankar@broadcom.com
Subject: [PATCH] Staging: crystalhd: Remove unused header bc_dts_types.h
Message-ID: <20120226021910.GA29831@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header bc_dts_types is not used, so we can remove it.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/bc_dts_types.h |   40 ------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)
 delete mode 100644 drivers/staging/crystalhd/bc_dts_types.h

diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
deleted file mode 100644
index 1085a91..0000000
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/********************************************************************
- * Copyright(c) 2006-2009 Broadcom Corporation.
- *
- *  Name: bc_dts_types.h
- *
- *  Description: Data types
- *
- *  AU
- *
- *  HISTORY:
- *
- ********************************************************************
- * This header is free software: you can redistribute it and/or modify
- * it under the terms of the GNU Lesser General Public License as published
- * by the Free Software Foundation, either version 2.1 of the License.
- *
- * This header is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- * You should have received a copy of the GNU Lesser General Public License
- * along with this header.  If not, see <http://www.gnu.org/licenses/>.
- *******************************************************************/
-
-#ifndef _BC_DTS_TYPES_H_
-#define _BC_DTS_TYPES_H_
-
-#include <stdint.h>
-
-#ifndef TRUE
-	#define TRUE		1
-#endif
-
-#ifndef FALSE
-	#define FALSE		0
-#endif
-
-#define TEXT
-
-#endif
-- 
1.7.2.5


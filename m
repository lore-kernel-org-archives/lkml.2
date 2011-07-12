Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab1GLD17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 23:27:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:59513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab1GLD16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 23:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,518,1304319600"; 
   d="scan'208";a="26011572"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Documentation/x86: correct real-mode kernel header offset for init_size
Date: Mon, 11 Jul 2011 20:27:40 -0700
Message-Id: <541cf88e2dfe5b8186d8b96b136d892e769a68c1.1310441260.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real-mode kernel header init_size field is located at 0x260 per the field
listing in th e"REAL-MODE KERNEL HEADER" section. It is listed as 0x25c in
the "DETAILS OF HEADER FIELDS" section, which overlaps with pref_address.
Correct the details listing to 0x260.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/x86/boot.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9b7221a..7c3a880 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -674,7 +674,7 @@ Protocol:	2.10+
 
 Field name:	init_size
 Type:		read
-Offset/size:	0x25c/4
+Offset/size:	0x260/4
 
   This field indicates the amount of linear contiguous memory starting
   at the kernel runtime start address that the kernel needs before it
-- 
1.7.1


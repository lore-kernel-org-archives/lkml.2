Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2CERd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:33:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40475 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab2CERd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:33:56 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 5/5] staging: zsmalloc: remove SPARSEMEM dep from Kconfig
Date: Mon,  5 Mar 2012 11:33:24 -0600
Message-Id: <1330968804-8098-6-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030517-7182-0000-0000-000000F6A168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the SPARSEMEM from the zsmalloc
Kconfig

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index 8e2c6a0..a5ab720 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -3,7 +3,7 @@ config ZSMALLOC
 	# X86 dependency is because of the use of __flush_tlb_one and set_pte
 	# in zsmalloc-main.c.
 	# TODO: convert these to portable functions
-	depends on SPARSEMEM && X86
+	depends on X86
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
-- 
1.7.5.4


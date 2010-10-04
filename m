Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0JDKrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:47:13 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:36990 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab0JDKrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:47:11 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 06:47:11 EDT
X-ClientAddr: 91.119.0.188
Date: Mon, 4 Oct 2010 12:39:01 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Alessandro Rubini <rubini@unipv.it>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] arm/nomadik: remove duplicated include
Message-ID: <20101004123901.6374d158@absol.kitzblitz>
In-Reply-To: <20101004122436.7092868f@absol.kitzblitz>
References: <20101004122436.7092868f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o94AXLMN020440
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 5fbde4b..93a8126 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -14,7 +14,6 @@
 #include <linux/dmaengine.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
-#include <linux/dmaengine.h>
 
 /* dev types for memcpy */
 #define STEDMA40_DEV_DST_MEMORY (-1)
-- 
1.7.2.2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1COBjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:39:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21073 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1COBji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:39:38 -0400
Date: Tue, 15 Mar 2011 02:39:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: Remove bouncing author email from
 arch/arm/plat-iop/time.c
Message-ID: <alpine.LNX.2.00.1103150236500.26293@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Deepak Saxena's email address, listed at the head of 
arch/arm/plat-iop/time.c, bounces. Remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 07f23bb..af6139d 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -3,7 +3,7 @@
  *
  * Timer code for IOP32x and IOP33x based systems
  *
- * Author: Deepak Saxena <dsaxena@mvista.com>
+ * Author: Deepak Saxena
  *
  * Copyright 2002-2003 MontaVista Software Inc.
  *


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2IYFEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:04:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43070 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2IYFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:04:41 -0400
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 3/3] Staging:bcm: fix coding style error in InterfaceIsr.c
Date: Tue, 25 Sep 2012 11:04:29 +0600
Message-Id: <1348549469-7222-2-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348549469-7222-1-git-send-email-revent82@gmail.com>
References: <1348549469-7222-1-git-send-email-revent82@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the InterfaceIsr.c file that
fixes up a coding style issues found by the checkpatch.pl tool

Signed-off-by: Ilya Gorskin <revent82@gmail.com>
---
 drivers/staging/bcm/InterfaceIsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index 4f78451..0e68485 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -120,7 +120,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			urb->status = STATUS_SUCCESS ;
 			break ;
 			/*return;*/
-		default:
+	default:
 			/*This is required to check what is the defaults
 			* conditions when it occurs..*/
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
-- 
1.7.12


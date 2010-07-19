Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966565Ab0GSVo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:44:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37514 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966851Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213851.278243413@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:19 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 01/25] GRU - delete obsolete gru instruction opcodes
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_no_poll
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the GRU instruction macros to match what is actually
implemented in initial silicon.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gru_instructions.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:31.528038315 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2010-06-09 08:11:38.907960603 -0500
@@ -217,8 +217,6 @@ struct gru_instruction {
 #define EOP_ERR_XOR	0x03 /* Logical XOR with memory */
 #define EOP_ERR_ADD	0x04 /* Add value to memory */
 #define EOP_ERR_CSWAP	0x08 /* Compare with operand2, write operand1 if match*/
-#define EOP_ERR_EPOLL	0x09 /* Poll for equality */
-#define EOP_ERR_NPOLL	0x0a /* Poll for inequality */
 
 /* GAMXR - SGI Arithmetic unit */
 #define EOP_XR_CSWAP	0x0b /* Masked compare exchange */


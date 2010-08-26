Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab0HZNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:21:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33096 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181Ab0HZNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:24 -0400
Message-Id: <20100826132123.149180792@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:38 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 01/25] GRU - delete obsolete gru instruction opcodes
References: <20100826131937.108920216@sgi.com>
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


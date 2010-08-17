Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab0HQQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:53:00 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:11642 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552Ab0HQQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:52:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAJdaakzCTtAn/2dsb2JhbACTJ40XccFBhTcEiWc
Date: Tue, 17 Aug 2010 18:52:39 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68knommu: whitespace cleanup in 68328/entry.S
Message-ID: <20100817165239.GA16734@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68knommu: whitespace cleanup in 68328/entry.S

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
--- a/arch/m68knommu/platform/68328/entry.S
+++ b/arch/m68knommu/platform/68328/entry.S
@@ -43,7 +43,7 @@ badsys:
 	jra	ret_from_exception
 
 do_trace:
-	movel	#-ENOSYS,%sp@(PT_OFF_D0)	/* needed for strace*/
+	movel	#-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
@@ -57,7 +57,7 @@ do_trace:
 	lea	sys_call_table, %a0
 	jbsr	%a0@(%d1)
 
-1:	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
+1:	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
 	subql	#4,%sp			/* dummy return address */
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
@@ -71,9 +71,9 @@ ENTRY(system_call)
 	SAVE_ALL
 
 	/* save top of frame*/
-	pea     %sp@
-	jbsr    set_esp0
-	addql   #4,%sp
+	pea	%sp@
+	jbsr	set_esp0
+	addql	#4,%sp
 
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 
@@ -88,10 +88,10 @@ ENTRY(system_call)
 	lea	sys_call_table,%a0
 	movel	%a0@(%d0), %a0
 	jbsr	%a0@
-	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value*/
+	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value*/
 
 ret_from_exception:
-	btst	#5,%sp@(PT_OFF_SR)		/* check if returning to kernel*/
+	btst	#5,%sp@(PT_OFF_SR)	/* check if returning to kernel*/
 	jeq	Luser_return		/* if so, skip resched, signals*/
 
 Lkernel_return:

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1C1SrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:47:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34341 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1C1SrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:47:04 -0400
Date: Mon, 28 Mar 2011 11:46:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/kernel-parameters: clarify panic options
Message-Id: <20110328114656.7e7da60e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D90D7A2.00D2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add a little more info for some of the panic-related kernel parameters.
Fix "oops=panic" to fit in 80 columns.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-2.6.38-git18.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.38-git18/Documentation/kernel-parameters.txt
@@ -1832,15 +1832,17 @@ bytes respectively. Such letter suffixes
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
-	oops=panic	Always panic on oopses. Default is to just kill the process,
-			but there is a small probability of deadlocking the machine.
+	oops=panic	Always panic on oopses. Default is to just kill the
+			process, but there is a small probability of
+			deadlocking the machine.
 			This will also cause panics on machine check exceptions.
 			Useful together with panic=30 to trigger a reboot.
 
 	OSS		[HW,OSS]
 			See Documentation/sound/oss/oss-parameters.txt
 
-	panic=		[KNL] Kernel behaviour on panic
+	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
+			seconds before rebooting
 			Format: <timeout>
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
@@ -2343,6 +2345,7 @@ bytes respectively. Such letter suffixes
 
 	softlockup_panic=
 			[KNL] Should the soft-lockup detector generate panics.
+			Format: <integer>
 
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/sonypi.txt
@@ -2529,8 +2532,7 @@ bytes respectively. Such letter suffixes
 			reported either.
 
 	unknown_nmi_panic
-			[X86]
-			Set unknown_nmi_panic=1 early on boot.
+			[X86] Cause panic on unknown NMI.
 
 	usbcore.autosuspend=
 			[USB] The autosuspend time delay (in seconds) used

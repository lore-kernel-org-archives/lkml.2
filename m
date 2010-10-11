Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0JKRxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:53:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47648 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab0JKRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:53:47 -0400
Message-ID: <4CB34F18.80505@kernel.org>
Date: Mon, 11 Oct 2010 10:53:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, setup: Use puts() instead of printf() in edd code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need to use printf there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/edd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/boot/edd.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/edd.c
+++ linux-2.6/arch/x86/boot/edd.c
@@ -156,7 +156,7 @@ void query_edd(void)
 	 */
 
 	if (!be_quiet)
-		printf("Probing EDD (edd=off to disable)... ");
+		puts("Probing EDD (edd=off to disable)... ");
 
 	for (devno = 0x80; devno < 0x80+EDD_MBR_SIG_MAX; devno++) {
 		/*
@@ -175,7 +175,7 @@ void query_edd(void)
 	}
 
 	if (!be_quiet)
-		printf("ok\n");
+		puts("ok\n");
 }
 
 #endif

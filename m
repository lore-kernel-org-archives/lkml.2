Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0H2XCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:02:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31626 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0H2XCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:02:17 -0400
Message-ID: <4C7AE695.7080409@kernel.org>
Date: Sun, 29 Aug 2010 16:00:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, setup: use puts instead of printf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need to used printf there.

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

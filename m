Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1CRLVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:21:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1CRLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UpT6vkiusV229HX+DfOcXoNltpSSlVzguE79JXvBcbnOoE6/hW4lidgfEVfCEPDr9m
         UYLh5efYk5YU01ltegpq5TyAkxXywrWYUGuBbbNMOWm8DUjItkxg07AmfpUMDy8sxnPZ
         1adH294TKbpPDGoiAY4i0aRWwJnXz/TXNlpz0=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC 2/2] x86, dumpstack: use %pT format specifier for stack trace
Date: Fri, 18 Mar 2011 20:21:18 +0900
Message-Id: <1300447278-2073-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
References: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 914065620f2c..809d027de28f 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,7 +27,7 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk(" [<%p>] %s%pT\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
-- 
1.7.4


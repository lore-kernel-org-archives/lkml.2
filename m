Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1CWMrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:47:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39097 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1CWMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tpLKcRlJTwcU9WkFpJTAqFwbW+Ke6sBE5rUAicoGOdKdMVu1mHtPIH74LHJUzBiaXq
         EGMHu7mgKNykfuckUmAXVY7+AY6pNq/XvJ0PHf29parHsCR+wxBoR8SVfAsmPjzBmN5n
         gmVrev4RpWYczVPjDNucaOMPVktaCJSaemECs=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 2/2] x86, dumpstack: use %pT format specifier for stack trace
Date: Wed, 23 Mar 2011 21:46:35 +0900
Message-Id: <1300884395-13835-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
References: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
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


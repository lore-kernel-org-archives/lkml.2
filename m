Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0JOPSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:18:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab0JOPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=f7yz2So88rcbcbZMY03QAephUsKbm+kIusQSXCXrXO6dqAi5iptuxqmp7ZPk32/mZY
         M89HkCicaUdqC7ibVW+4D9FPtlrLyxttTqAzsuSoSnm6OKXWajBSFOcIyzTXuYcEJh9k
         Hg/vU0gx1JOknEmzT009VwQH0zYpOBPRAkLEo=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 02/13] arch: x86: mm: init_64.c: Removed duplicated #include
Date: Fri, 15 Oct 2010 17:18:14 +0200
Message-Id: <1287155896-11616-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.1.181.g784b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/x86/mm/init_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..612f353 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,7 +50,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
 
-- 
1.7.2.1.85.g2d089


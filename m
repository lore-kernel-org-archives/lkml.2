Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0DMPrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0DMPrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:47:19 -0400
Date: Tue, 13 Apr 2010 11:47:15 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
       dnelson@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100413154715.23179.40700.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: x86: remove extra bootmem.h from arch/x86/mm/init_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resubmitting to wider audience...]

bootmem.h is already included in init_64.c.  Remove the second include.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ee41bba..a9474fc 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,7 +50,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
 

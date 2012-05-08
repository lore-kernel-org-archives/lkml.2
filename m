Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2EHPYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:24:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58692 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2EHPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:24:44 -0400
Message-ID: <1336490654.1179.38.camel@mop>
Subject: [PATCH] mm: use KERN_CONT in printk() continuation lines
From: Kay Sievers <kay@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 17:24:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: mm: use KERN_CONT in printk() continuation lines

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4763,12 +4763,12 @@ void __init free_area_init_nodes(unsigne
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk("  %-8s ", zone_names[i]);
+		printk(KERN_CONT "  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk("empty\n");
+			printk(KERN_CONT "empty\n");
 		else
-			printk("%0#10lx -> %0#10lx\n",
+			printk(KERN_CONT "%0#10lx -> %0#10lx\n",
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
 	}



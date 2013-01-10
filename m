Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3AJA6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:58:01 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56761 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3AJA6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:58:00 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] MAINTAINERS: mm: add additional include files to listing
Date: Wed,  9 Jan 2013 16:12:25 -0800
Message-Id: <1357776745-10392-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011000-2876-0000-0000-000003EAA247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gfp.h, mmzone.h, memory_hotplug.h & vmalloc.h to the "MEMORY
MANAGMENT" section so scripts/get_maintainer.pl can do a better job of
making recommendations.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 915564e..e77ef28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5003,6 +5003,10 @@ L:	linux-mm@kvack.org
 W:	http://www.linux-mm.org
 S:	Maintained
 F:	include/linux/mm.h
+F:	include/linux/gfp.h
+F:	include/linux/mmzone.h
+F:	include/linux/memory_hotplug.h
+F:	include/linux/vmalloc.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
-- 
1.8.0.3


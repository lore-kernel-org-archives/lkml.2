Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2KILrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:47:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54027 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2KILrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:47:49 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] ARM: mm: Remove unused variable in mmap.c
Date: Fri,  9 Nov 2012 17:12:00 +0530
Message-Id: <1352461320-22031-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable 'start_addr' is not used and hence can be removed.

Silences the following compilation warning:
arch/arm/mm/mmap.c: In function ‘arch_get_unmapped_area’:
arch/arm/mm/mmap.c:60:16: warning:
unused variable ‘start_addr’ [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This patch is based linux-next tree of 20121109
---
 arch/arm/mm/mmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index f4fec6d..10062ce 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -57,7 +57,6 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
 	struct vm_unmapped_area_info info;
-- 
1.7.4.1


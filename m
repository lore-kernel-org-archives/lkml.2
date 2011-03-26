Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1CZQ1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:27:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1CZQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xu9RB4IbgWmU6gwHEMRxzjr0HiFt4FFIttQqyl9N4UmIzV9RIJpGqiHvc27ubBhzm9
         Ha6jT31/HsFJ7JOQNdkC1b1HzMu2jJri3pheNIu4mmTKagl5np+j7ohkh/NTh6OHJn+Y
         Psz+MdFNC9J6nH1hvZ9NuA1tybXfrwfIdtiVo=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 2/2] Fixed the format that column is longer than 80 .
Date: Sun, 27 Mar 2011 00:25:26 +0800
Message-Id: <1301156726-23610-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
References: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/memory.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 mm/memory.c

diff --git a/mm/memory.c b/mm/memory.c
old mode 100644
new mode 100755
index 615be51..422cba6
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2196,7 +2196,8 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 	return same;
 }
 
-static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
+static inline void cow_user_page(struct page *dst, struct page *src,
+				unsigned long va, struct vm_area_struct *vma)
 {
 	/*
 	 * If the source page was a PFN mapping, we don't have
@@ -2940,7 +2941,8 @@ out_release:
  * except we must first make sure that 'address{-|+}PAGE_SIZE'
  * doesn't hit another vma.
  */
-static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
+static inline int check_stack_guard_page(struct vm_area_struct *vma,
+					unsigned long address)
 {
 	address &= PAGE_MASK;
 	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
@@ -3653,7 +3655,8 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
  * Source/target buffer must be kernel space,
  * Do not walk the page table directly, use get_user_pages
  */
-int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+int access_process_vm(struct task_struct *tsk, unsigned long addr,
+			void *buf, int len, int write)
 {
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-- 
1.7.3


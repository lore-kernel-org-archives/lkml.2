Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2LFBCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:02:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41098 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2LFBCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:02:00 -0500
Date: Thu, 6 Dec 2012 12:01:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] propagate name change to comments in kernel source
Message-Id: <20121206120148.99919a3512c72947c8baba67@canb.auug.org.au>
In-Reply-To: <1354754668.9720.198.camel@tisifone>
References: <1354754668.9720.198.camel@tisifone>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Dec_2012_12_01_48_+1100_Fw1tcgUDH/dOT6lU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Dec_2012_12_01_48_+1100_Fw1tcgUDH/dOT6lU
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__6_Dec_2012_12_01_48_+1100_TePagjVrJkMBTvUI"


--Multipart=_Thu__6_Dec_2012_12_01_48_+1100_TePagjVrJkMBTvUI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nadia,

On Wed, 05 Dec 2012 19:44:28 -0500 Nadia Yvette Chambers <nyc@holomorphy.co=
m> wrote:
>
> I've legally changed my name with New York State, the US Social Security
> Administration, et al. This patch propagates the name change and change
> in initials and login to comments in the kernel source as well.
>=20
> vs. next-20121205

OK, that may be a problem.  Does this patch apply to Linus' tree
currently?  I guess not.  So, either you need to split it up and send it
to the various maintainers (most if it can probably go through the trivial
tree (cc'd)).  Or wait until after v3.8-rc1 and fix it so it applies to
Linus' tree and send it to him.

Or Andrew (cc'd) may be able to take it (as his tree is based on
linux-next currently).

(I have attached the patch for Jiri's and Andrew's benefit)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Multipart=_Thu__6_Dec_2012_12_01_48_+1100_TePagjVrJkMBTvUI
Content-Type: text/x-diff;
 name="wli-nyc-name_change.patch"
Content-Disposition: attachment;
 filename="wli-nyc-name_change.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/MAINTAINERS b/MAINTAINERS
index 26c7b01..b3055a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3659,7 +3659,7 @@ S:	Maintained
 F:	drivers/input/touchscreen/htcpen.c
=20
 HUGETLB FILESYSTEM
-M:	William Irwin <wli@holomorphy.com>
+M:	Nadia Yvette Chambers <nyc@holomorphy.com>
 S:	Maintained
 F:	fs/hugetlbfs/
=20
diff --git a/arch/alpha/include/asm/mmzone.h b/arch/alpha/include/asm/mmzon=
e.h
index 445dc42..c5b5d6b 100644
--- a/arch/alpha/include/asm/mmzone.h
+++ b/arch/alpha/include/asm/mmzone.h
@@ -66,7 +66,7 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p, int n)
     ((unsigned long)__va(NODE_DATA(kvaddr_to_nid(kaddr))->node_start_pfn  \
 			 << PAGE_SHIFT))
=20
-/* XXX: FIXME -- wli */
+/* XXX: FIXME -- nyc */
 #define kern_addr_valid(kaddr)	(0)
=20
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index 4fb63a3..f6084bc 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -77,7 +77,7 @@ void __set_pmd(pmd_t *pmdptr, unsigned long pmd)
  * checks at dup_mmap(), exec(), and other mmlist addition points
  * could be used. The locking scheme was chosen on the basis of
  * manfred's recommendations and having no core impact whatsoever.
- * -- wli
+ * -- nyc
  */
 DEFINE_SPINLOCK(pgd_lock);
 struct page *pgd_list;
diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index 4ebf117..bd9ada6 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -95,7 +95,7 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned=
 long address)
  * checks at dup_mmap(), exec(), and other mmlist addition points
  * could be used. The locking scheme was chosen on the basis of
  * manfred's recommendations and having no core impact whatsoever.
- * -- wli
+ * -- nyc
  */
 DEFINE_SPINLOCK(pgd_lock);
 struct page *pgd_list;
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 7353de3..e27fbf8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -137,7 +137,7 @@ static void pgd_dtor(pgd_t *pgd)
  * against pageattr.c; it is the unique case in which a valid change
  * of kernel pagetables can't be lazily synchronized by vmalloc faults.
  * vmalloc faults work because attached pagetables are never freed.
- * -- wli
+ * -- nyc
  */
=20
 #ifdef CONFIG_X86_PAE
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4a55f35..78bde32 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1,7 +1,7 @@
 /*
  * hugetlbpage-backed filesystem.  Based on ramfs.
  *
- * William Irwin, 2002
+ * Nadia Yvette Chambers, 2002
  *
  * Copyright (C) 2002 Linus Torvalds.
  */
diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index be20a7e..63d14a9 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -89,7 +89,7 @@ static int ncp_file_mmap_fault(struct vm_area_struct *are=
a,
 	/*
 	 * If I understand ncp_read_kernel() properly, the above always
 	 * fetches from the network, here the analogue of disk.
-	 * -- wli
+	 * -- nyc
 	 */
 	count_vm_event(PGMAJFAULT);
 	mem_cgroup_count_vm_event(area->vm_mm, PGMAJFAULT);
diff --git a/include/linux/hash.h b/include/linux/hash.h
index 24df9e7..61c97ae 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_HASH_H
 #define _LINUX_HASH_H
 /* Fast hashing routine for ints,  longs and pointers.
-   (C) 2002 William Lee Irwin III, IBM */
+   (C) 2002 Nadia Yvette Chambers, IBM */
=20
 /*
  * Knuth recommends primes in approximately golden ratio to the maximum
diff --git a/kernel/pid.c b/kernel/pid.c
index e8750f9..36aa02f 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -1,8 +1,8 @@
 /*
  * Generic pidhash and scalable, time-bounded PID allocator
  *
- * (C) 2002-2003 William Irwin, IBM
- * (C) 2004 William Irwin, Oracle
+ * (C) 2002-2003 Nadia Yvette Chambers, IBM
+ * (C) 2004 Nadia Yvette Chambers, Oracle
  * (C) 2002-2004 Ingo Molnar, Red Hat
  *
  * pid-structures are backing objects for tasks sharing a given ID to chain
diff --git a/kernel/profile.c b/kernel/profile.c
index 76b8e77..1f39181 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -8,9 +8,10 @@
  *  Scheduler profiling support, Arjan van de Ven and Ingo Molnar,
  *	Red Hat, July 2004
  *  Consolidation of architecture support code for profiling,
- *	William Irwin, Oracle, July 2004
+ *	Nadia Yvette Chambers, Oracle, July 2004
  *  Amortized hit count accounting via per-cpu open-addressed hashtables
- *	to resolve timer interrupt livelocks, William Irwin, Oracle, 2004
+ *	to resolve timer interrupt livelocks, Nadia Yvette Chambers,
+ *	Oracle, 2004
  */
=20
 #include <linux/export.h>
@@ -256,7 +257,7 @@ EXPORT_SYMBOL_GPL(unregister_timer_hook);
  * pagetable hash functions, but uses a full hashtable full of finite
  * collision chains, not just pairs of them.
  *
- * -- wli
+ * -- nyc
  */
 static void __profile_flip_buffers(void *unused)
 {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7693aaf..afd092d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -10,7 +10,7 @@
  * Based on code in the latency_tracer, that is:
  *
  *  Copyright (C) 2004-2006 Ingo Molnar
- *  Copyright (C) 2004 William Lee Irwin III
+ *  Copyright (C) 2004 Nadia Yvette Chambers
  */
=20
 #include <linux/stop_machine.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5bc3590..e512567 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9,7 +9,7 @@
  *
  * Based on code from the latency_tracer, that is:
  *  Copyright (C) 2004-2006 Ingo Molnar
- *  Copyright (C) 2004 William Lee Irwin III
+ *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/ring_buffer.h>
 #include <generated/utsrelease.h>
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index bb227e3..8e3ad80 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -7,7 +7,7 @@
  * Based on code from the latency_tracer, that is:
  *
  *  Copyright (C) 2004-2006 Ingo Molnar
- *  Copyright (C) 2004 William Lee Irwin III
+ *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/ring_buffer.h>
 #include <linux/debugfs.h>
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5ffce7b..713a2ca 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -7,7 +7,7 @@
  * From code in the latency_tracer, that is:
  *
  *  Copyright (C) 2004-2006 Ingo Molnar
- *  Copyright (C) 2004 William Lee Irwin III
+ *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/kallsyms.h>
 #include <linux/debugfs.h>
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index bc64fc1..9fe45fc 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -7,7 +7,7 @@
  * Based on code from the latency_tracer, that is:
  *
  *  Copyright (C) 2004-2006 Ingo Molnar
- *  Copyright (C) 2004 William Lee Irwin III
+ *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/module.h>
 #include <linux/fs.h>
diff --git a/kernel/wait.c b/kernel/wait.c
index 7fdd9ea..6698e0c 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -1,7 +1,7 @@
 /*
  * Generic waiting primitives.
  *
- * (C) 2004 William Irwin, Oracle
+ * (C) 2004 Nadia Yvette Chambers, Oracle
  */
 #include <linux/init.h>
 #include <linux/export.h>
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06fdfa1..06f7e4f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -353,7 +353,7 @@ again:
 EXPORT_SYMBOL(bitmap_find_next_zero_area);
=20
 /*
- * Bitmap printing & parsing functions: first version by Bill Irwin,
+ * Bitmap printing & parsing functions: first version by Nadia Yvette Cham=
bers,
  * second version by Paul Jackson, third by Joe Korty.
  */
=20
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8518efc..cf6a869 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1,6 +1,6 @@
 /*
  * Generic hugetlb support.
- * (C) William Irwin, April 2004
+ * (C) Nadia Yvette Chambers, April 2004
  */
 #include <linux/list.h>
 #include <linux/init.h>
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 965f003..2247089 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -525,7 +525,7 @@ static inline int page_is_buddy(struct page *page, stru=
ct page *buddy,
  * If a block is freed, and its buddy is also free, then this
  * triggers coalescing into a block of larger size.
  *
- * -- wli
+ * -- nyc
  */
=20
 static inline void __free_one_page(struct page *page,
@@ -792,7 +792,7 @@ void __init init_cma_reserved_pageblock(struct page *pa=
ge)
  * large block of memory acted on by a series of small allocations.
  * This behavior is a critical factor in sglist merging's success.
  *
- * -- wli
+ * -- nyc
  */
 static inline void expand(struct zone *zone, struct page *page,
 	int low, int high, struct free_area *area,

--Multipart=_Thu__6_Dec_2012_12_01_48_+1100_TePagjVrJkMBTvUI--

--Signature=_Thu__6_Dec_2012_12_01_48_+1100_Fw1tcgUDH/dOT6lU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQv+58AAoJEECxmPOUX5FEkzYP/0OlIH7xdOURxVIMK1Bfz8yr
fcXBNzS6w/XQdOVvQHA5VUxKjVuQzE5AJv/Nlt26IcTmGirWmGb33eZGW7hW6iBH
7OnaxSLlxxNppIJHEaX59rUtNS5N6OVajso+hckxyZ8M6aQq5WLTJufJ8rUE8flx
8osss7X5WQh0vrQgud74IFVkfDJkMc2760erE/cHEKFnC4C36rV8GkbSSC1Ly+BG
gkWtjyQtEHrHJXcocW2KHV6lY+mmKMLezy48Rbxz3fUHaIwZldTix9WQDBLVa2c6
gOweMjexHaXflvVs1SfHSDS/czPa7Vdk55FjhNu0PwlVjIkOfLeVHubaI6n7HByK
pP3v6bsAnDUggMYbT8QenQ0wN6UmOqPV2QeEdMbATYH3J4dil8xSf4R1Fl7LhWyg
K/PLTMRuO9AhE43/mplbNUZjTYLt5Li8Sy2byktFBB8c/nalduHXD4KITrbpxSSM
SLJBTbRqOd48dbavEyOO96mqkrvwe18lv0CtYNfWR0wXaQv46c/LgwpDaKNsWqDR
8H7mkkghgreIlZNxvr3mcMKOHybpygpwzNPM/144Rq8FCtGiPJClsYuov9jBQ/nK
JowsgKhOsOgf83GFJXNNXjs/ZX6ogM4tFYZdkSA+bk8bcMzbtv9rmOsOnU0VX7Bh
k/pCYTkCphuOo1uc2b4N
=keKw
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Dec_2012_12_01_48_+1100_Fw1tcgUDH/dOT6lU--

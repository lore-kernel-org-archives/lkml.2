Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2KIHlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:41:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51241 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2KIHla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:41:30 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-37-509cb3a9d862
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mm: mmap: remove unused variable
Date: Fri, 09 Nov 2012 16:41:28 +0900
Message-id: <000101cdbe4d$a1335eb0$e39a1c10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2+TaEY9JWsllmMRpS3ttcqSd3Uzg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ92Vm+cEGPy7ymdxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyLp2axVywlq1i5detbA2MS1i7GDk5JARMJE6fuMMOYYtJXLi3
	nq2LkYtDSGAZo8SyJceYuhg5wIo+/06AiE9nlLh8bg4zhDObSWLf0o9gk9gE1CS+fDkMNklE
	wFfi++INTCA2s4CVxL4PG8BqhAUMJVZuO8wKMpRFQFXi3JZMkDCvgK3EtZUf2CFsQYkfk++x
	QLRqSazfeRxqjLzE5jVvmSHuUZd49FcXxBQR0JN4uN0EokJEYt+Ld4wgNouAgMS3yYdYIKpl
	JTYdADtYQqCdXeLusUNsEO9KShxccYNlAqPYLCSLZyFZPAvJ4llIVixgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERIlUjsYVzZYHGIU4GBU4uFNfDA7QIg1say4MvcQowQHs5II79zM
	OQFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M4LySeENjYxMzE1MTc0tTc1McwkrivM0e
	KQFCAumJJanZqakFqUUw45g4OKUaGNWltohu05LJknX8fvLLz8iaL85rpZ/de77J4Z7XZgPd
	9ozsbdvKHTrEGAxPfPji6PJ/68/en719r+78PfyTcwl7szyzwcI6nf3nb+x6z7jrf9cRSW+F
	2fknu14f/KH4xJ6Z8UhNB9uJh3IMbyIzJLRNwrt6fx288Mh90u5jrzyurMrnn8nSnqXEUpyR
	aKjFXFScCABSSHWnvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd2Vm+cEGOxu5ba4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZdOzWIuWMtWsfLrVrYG
	xiWsXYwcHBICJhKffyd0MXICmWISF+6tZ+ti5OIQEpjOKHH53BxmCGc2k8S+pR9ZQarYBNQk
	vnw5zA5iiwj4SnxfvIEJxGYWsJLY92EDWI2wgKHEym2HwRawCKhKnNuSCRLmFbCVuLbyAzuE
	LSjxY/I9FohWLYn1O49DjZGX2LzmLTPEbeoSj/7qgpgiAnoSD7ebQFSISOx78Y5xAqPALCSD
	ZiEZNAvJoFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7BZ1I7GFc2WBxiFOBg
	VOLhTXwwO0CINbGsuDL3EKMEB7OSCO/czDkBQrwpiZVVqUX58UWlOanFhxh9gN6cyCwlmpwP
	TA95JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTA6HTq9b07y
	zxki2hGGz+u3Cca4fm9a8+LnWbmXb85tXnG3wuZx7vyNDiFWXrvDHt1b6TqPN/CwoveyLP3X
	W0vXdT7zOb0yp9r3vfDOPz+kphhLfoxIdN/ns3TOzXzFbp6rGwMWLroxPzb8iRjbSlflqMfM
	1Xn5tyIY815qPvtUumLrtEMTph1ZpMRSnJFoqMVcVJwIADDzGbLuAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed build warning as below:

arch/arm/mm/mmap.c: In function 'arch_get_unmapped_area':
arch/arm/mm/mmap.c:60:16: warning: unused variable 'start_addr' [-Wunused-variable]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
This patch is based on linux-next-20121109 code tree.

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
1.7.1



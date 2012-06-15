Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2FOTlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:41:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab2FOTlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:41:14 -0400
Message-ID: <4FDB8FC9.2020909@jp.fujitsu.com>
Date: Fri, 15 Jun 2012 15:40:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: liwp.linux@gmail.com
CC: trivial@kernel.org, benh@kernel.crashing.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, bhelgaas@google.com,
        hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org, lizefan@huawei.com,
        cl@linux-foundation.org, paul.gortmaker@windriver.com,
        jbarnes@virtuousgeek.org, miltonm@bga.com, nacc@us.ibm.com,
        sfr@canb.auug.org.au, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, jan.kiszka@siemens.com,
        dhowells@redhat.com, srikar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mel@csn.ul.ie, minchan@kernel.org,
        shangw@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        aarcange@redhat.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, hughd@google.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 7/7] mm/memory.c : cleanup the coding style issue
References: <1339766449-7835-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1339766449-7835-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/memory.c b/mm/memory.c
> index 1b7dc66..195d6e1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2447,7 +2447,8 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
>  	return same;
>  }
>  
> -static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
> +static inline void cow_user_page(struct page *dst, struct page *src,
> +		unsigned long va, struct vm_area_struct *vma)
>  {
>  	/*
>  	 * If the source page was a PFN mapping, we don't have

Nowadays, many developers prefer to declare a function in one line. and we don't think
this is incorrect anymore. so, I think this is intentional.

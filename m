Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1C0KA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 06:00:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62913 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1C0KAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 06:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cumjyrTC7Udz/WQmn4LRDEtwItgDAtGXSkzAhyWo0zbL7LJHLxH9sKxE1qatWjQQ2k
         2tfDtMBiLCcWrttAYhT+D+o0aXLTFc41ilBqvPDD628pEAGrYJLf9aooW4PzBB2FK9C7
         zkNuGaJ8Y7kvVJ2i+CxkuHHBomaSqwvOBo+rs=
Date: Sun, 27 Mar 2011 18:00:05 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 2/2] Fixed the format that column is longer than 80 .
Message-ID: <20110327100001.GB3815@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>,
	linux-kernel@vger.kernel.org, greg@kroah.com
References: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
 <1301156726-23610-2-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301156726-23610-2-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 12:25:26AM +0800, Wanlong Gao wrote:
Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  mm/memory.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>  mode change 100644 => 100755 mm/memory.c
> 
> diff --git a/mm/memory.c b/mm/memory.c
> old mode 100644
> new mode 100755
> index 615be51..422cba6
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2196,7 +2196,8 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
>  	return same;
>  }
>  
> -static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
> +static inline void cow_user_page(struct page *dst, struct page *src,
> +				unsigned long va, struct vm_area_struct *vma)
>  {
>  	/*
>  	 * If the source page was a PFN mapping, we don't have
> @@ -2940,7 +2941,8 @@ out_release:
>   * except we must first make sure that 'address{-|+}PAGE_SIZE'
>   * doesn't hit another vma.
>   */
> -static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
> +static inline int check_stack_guard_page(struct vm_area_struct *vma,
> +					unsigned long address)
>  {
>  	address &= PAGE_MASK;
>  	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
> @@ -3653,7 +3655,8 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>   * Source/target buffer must be kernel space,
>   * Do not walk the page table directly, use get_user_pages
>   */
> -int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
> +int access_process_vm(struct task_struct *tsk, unsigned long addr,
> +			void *buf, int len, int write)
>  {
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -- 
> 1.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

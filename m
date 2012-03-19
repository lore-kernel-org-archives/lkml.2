Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2CSAfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:35:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52068 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2CSAfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:35:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F667ED4.60204@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 09:33:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kautuk Consul <consul.kautuk@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TRIVIAL: mmap.c: fix comment for __insert_vm_struct()
References: <1331918590-2786-1-git-send-email-consul.kautuk@gmail.com>
In-Reply-To: <1331918590-2786-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/17 2:23), Kautuk Consul wrote:

> The comment above __insert_vm_struct seems to suggest that this
> function is also going to link the VMA with the anon_vma, but
> this is not true.
> This function only links the VMA to the mm->mm_rb tree and the mm->mmap linked
> list.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  mm/mmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index da15a79..6328a36 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -452,8 +452,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
>  
>  /*
>   * Helper for vma_adjust in the split_vma insert case:
> - * insert vm structure into list and rbtree and anon_vma,
> - * but it has already been inserted into prio_tree earlier.
> + * insert vm structure into list and rbtree, but it has
> + * already been inserted into prio_tree earlier.
>   */
>  static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
>  {


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



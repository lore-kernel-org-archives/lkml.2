Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2HFICu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2HFICr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:02:47 -0400
Message-ID: <501F795F.9060709@redhat.com>
Date: Mon, 06 Aug 2012 15:59:27 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.1.14-1.el6_1 Thunderbird/3.1.14
MIME-Version: 1.0
To: Zhouping Liu <sanweidaying@gmail.com>
CC: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] hugetlb: update hugetlbpage.txt
References: <1344237996-8769-1-git-send-email-sanweidaying@gmail.com>
In-Reply-To: <1344237996-8769-1-git-send-email-sanweidaying@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 03:26 PM, Zhouping Liu wrote:

> commit f0f57b2b1(mm: move hugepage test examples to tools/testing/selftests/vm)
> moved map_hugetlb.c, hugepage-shm.c and hugepage-mmap.c tests into
> tools/testing/selftests/vm/ directory, but it didn't update hugetlbpage.txt
> 
> Signed-off-by: Zhouping Liu <sanweidaying@gmail.com>


Ack

> ---
>  Documentation/vm/hugetlbpage.txt | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index f8551b3..4ac359b 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -299,11 +299,17 @@ map_hugetlb.c.
>  *******************************************************************
>  
>  /*
> - * hugepage-shm:  see Documentation/vm/hugepage-shm.c
> + * map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
>   */
>  
>  *******************************************************************
>  
>  /*
> - * hugepage-mmap:  see Documentation/vm/hugepage-mmap.c
> + * hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
> + */
> +
> +*******************************************************************
> +
> +/*
> + * hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
>   */



-- 
Thanks
Dave

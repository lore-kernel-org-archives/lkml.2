Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1BXTIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:08:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1BXTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:08:37 -0500
Message-ID: <4D66AC9C.6080500@kernel.org>
Date: Thu, 24 Feb 2011 11:08:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm]
References: <20110224145128.GM7840@htj.dyndns.org>
In-Reply-To: <20110224145128.GM7840@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D66ACAA.0055,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 06:51 AM, Tejun Heo wrote:
> Ingo, please pull from the following git branch to receive four
> commits from Yinghai.  HEAD is d1b19426b0 (x86: Rename e820_table_* to
> pgt_buf_*).
> 
> The first three separate nobootmem code into mm/nobootmem.c and the
> last one renames e820_table_* variables to pgt_buf_*.  All four
> patches are cleanups and shouldn't cause any behavior difference.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> As usual, if HEAD doesn't appear, please pull from master.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> Thanks.
> 
> Yinghai Lu (4):
>       bootmem: Separate out CONFIG_NO_BOOTMEM code into nobootmem.c
>       bootmem: Move contig_page_data definition to bootmem.c/nobootmem.c
>       bootmem: Move __alloc_memory_core_early() to nobootmem.c
>       x86: Rename e820_table_* to pgt_buf_*
> 
>  arch/x86/include/asm/init.h |    6 +-
>  arch/x86/mm/init.c          |   20 +-
>  arch/x86/mm/init_32.c       |    8 +-
>  arch/x86/mm/init_64.c       |    4 +-
>  arch/x86/xen/mmu.c          |    2 +-
>  include/linux/mm.h          |    2 -
>  mm/Makefile                 |    8 +-
>  mm/bootmem.c                |  180 +-----------------
>  mm/nobootmem.c              |  435 +++++++++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c             |   37 ----
>  10 files changed, 472 insertions(+), 230 deletions(-)
>  create mode 100644 mm/nobootmem.c
> 

better to put first three into seperate branch. and it is with core code.
something like tip/mm

So will not pollute tip/x86/mm. and they can be pushed separately.

Thanks

Yinghai

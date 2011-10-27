Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1J0HOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:14:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44647 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1J0HOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:14:18 -0400
Message-ID: <4EA904BD.5060708@zytor.com>
Date: Thu, 27 Oct 2011 09:14:05 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/mm changes for v3.2
References: <20111026153600.GA819@elte.hu> <20111026163126.GC660@phenom.dumpdata.com> <6bee402a-c83c-4903-8cf3-24de582247f8@email.android.com> <20111027071054.GA14858@elte.hu>
In-Reply-To: <20111027071054.GA14858@elte.hu>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 09:10 AM, Ingo Molnar wrote:
> 
> Okay.
> 
> Linus, please ignore this pull request.
> 
> Peter, once you get some time please sort out which of these commits 
> we want to keep:
> 
>  b17a5f97d413: x86_32: Calculate additional memory needed by the fixmap
>  2e9fbad5955f: x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse
>  1938931a20da: x86, init : Move memblock_x86_reserve_range PGTABLE to find_early_table_space
>  d8ca7b16cfc1: Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
>  8e7f9f8d4076: x86, mm: Calculate precisely the memory needed by init_memory_mapping
> 
> for example 2e9fbad5955f looks independent.
> 

I'll take a look as soon as I can.

	-hpa


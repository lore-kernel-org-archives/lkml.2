Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715Ab0JFShb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:37:31 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:19010
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605Ab0JFSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:37:29 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9VT1U-01-QOQ-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 20:37:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/7] sh: Annotate oprofile_arch_exit() with __exit
 marker
Message-ID: <20101006183705.GX13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <4426d17460dc88dcb3d6e3af1b91af4db83785ae.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4426d17460dc88dcb3d6e3af1b91af4db83785ae.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.10 16:44:25, Matt Fleming wrote:
> In order to avoid a section mismatch we need to annotate
> oprofile_arch_exit() with an __exit marker.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

Looks good.

-Robert

> ---
>  arch/sh/oprofile/common.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/sh/oprofile/common.c b/arch/sh/oprofile/common.c
> index 449f842..93033d8 100644
> --- a/arch/sh/oprofile/common.c
> +++ b/arch/sh/oprofile/common.c
> @@ -29,7 +29,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  	return oprofile_perf_init(ops);
>  }
>  
> -void oprofile_arch_exit(void)
> +void __exit oprofile_arch_exit(void)
>  {
>  	oprofile_perf_exit();
>  }
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


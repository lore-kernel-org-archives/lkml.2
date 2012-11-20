Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2KTBmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:42:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:15728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2KTBmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:42:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,282,1352102400"; 
   d="scan'208";a="244600303"
Message-ID: <50AADF90.8090506@intel.com>
Date: Tue, 20 Nov 2012 09:40:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/58] arch/x86/kernel/cpu/common.c: Mark cpu_detect_tlb
 static
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org> <1353302917-13995-23-git-send-email-josh@joshtriplett.org>
In-Reply-To: <1353302917-13995-23-git-send-email-josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 01:28 PM, Josh Triplett wrote:
> Nothing outside of arch/x86/kernel/cpu/common.c references
> cpu_detect_tlb, so mark it static.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  arch/x86/kernel/cpu/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 7505f7b..eb12c08 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -482,7 +482,7 @@ u16 __read_mostly tlb_lld_4m[NR_INFO];
>   */
>  s8  __read_mostly tlb_flushall_shift = -1;
>  
> -void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
> +static void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
>  {
>  	if (this_cpu->c_detect_tlb)
>  		this_cpu->c_detect_tlb(c);
> 

Acked-by: Alex Shi <alex.shi@intel.com>

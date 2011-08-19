Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1HSW0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:26:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:49065 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab1HSW0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="41876743"
Subject: Re: [PATCH] x86, cpu: Add cpufeature flag for PCIDs
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Arun Thomas <arun.thomas@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Andre Przywara <andre.przywara@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Aug 2011 15:29:38 -0700
In-Reply-To: <1313782943-3898-1-git-send-email-arun.thomas@gmail.com>
References: <1313782943-3898-1-git-send-email-arun.thomas@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313792978.27592.2.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 12:42 -0700, Arun Thomas wrote:
> This patch add a flag for Process-Context Identifiers (PCIDs) aka
> Address Space Identifiers (ASIDs) aka Tagged TLB support.
> 
> Signed-off-by: Arun Thomas <arun.thomas@gmail.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 4258aac..f24ed51 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -114,6 +114,7 @@
>  #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
>  #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
>  #define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
> +#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
>  #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
>  #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
>  #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>


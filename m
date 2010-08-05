Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab0HEKsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:48:16 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5202 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0HEKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:48:10 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6OD9I-01-2FC-02
X-M-MSG: 
Date: Thu, 5 Aug 2010 12:32:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Josh Hunt <johunt@akamai.com>, Ingo Molnar <mingo@elte.hu>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juhlenko@akamai.com" <juhlenko@akamai.com>
Subject: Re: [PATCH] oprofile: add support for Intel processor model 30
Message-ID: <20100805103206.GM26154@erda.amd.com>
References: <1280968025-16969-1-git-send-email-johunt@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280968025-16969-1-git-send-email-johunt@akamai.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.10 20:27:05, Josh Hunt wrote:
> Newer Intel processors identifying themselves as model 30 are not recognized by
> oprofile.

> Tested using oprofile 0.9.6.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Applied to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

(I converted the model number to hex.)

Thanks Josh.

Ingo,

please (ff-only) pull this again for tip/perf/core. You already send
the pull request for Linus, but I think this patch will make it for
v2.6.36 too?

Thanks.

-Robert

> ---
>  arch/x86/oprofile/nmi_int.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index b28d2f1..6f95251 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -657,6 +657,7 @@ static int __init ppro_init(char **cpu_type)
>  		break;
>  	case 0x2e:
>  	case 26:
> +	case 30:
>  		spec = &op_arch_perfmon_spec;
>  		*cpu_type = "i386/core_i7";
>  		break;
> -- 
> 1.7.0.4
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


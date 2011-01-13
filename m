Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1ANAMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:12:50 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46010 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752187Ab1ANAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:12:44 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z426fnzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEZJRS-02-AH8-02
X-M-MSG: 
Date: Fri, 14 Jan 2011 00:55:03 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
Message-ID: <20110113235503.GY4739@erda.amd.com>
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.01.11 17:38:11, Shawn Bohrer wrote:
> Added missing core i7 models found in "Intel 64 and IA-32 Architectures
> Software Developer's Manual Volume 3B: System Programming Guide",
> Table B-1.  Tested with oprofile 0.9.6 on a:
> 
> model      : 44
> model name : Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

Andi,

please ACK.

Thanks,

-Robert

> ---
>  arch/x86/oprofile/nmi_int.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index e2b7b0c..1523313 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -678,6 +678,9 @@ static int __init ppro_init(char **cpu_type)
>  		break;
>  	case 0x1a:
>  	case 0x1e:
> +	case 0x1f:
> +	case 0x25:
> +	case 0x2c:
>  	case 0x2e:
>  		spec = &op_arch_perfmon_spec;
>  		*cpu_type = "i386/core_i7";
> -- 
> 1.7.3.4
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


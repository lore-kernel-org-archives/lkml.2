Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0IUIVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:21:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3433 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0IUIVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:21:06 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zzbb2cK1432N98dN4015Lzz1202hzz8275bh5eeePz32i2a8h43h)
X-WSS-ID: 0L938IK-01-JBO-02
X-M-MSG: 
Date: Tue, 21 Sep 2010 10:20:44 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Message-ID: <20100921082044.GS13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.10 03:26:35, Jiri Olsa wrote:
> This patch adds CPU type detection for dunnington processor (Family 6 / Model 29)
> to be identified as core 2 family cpu type (wikipedia source).
> 
> I tested oprofile on Intel(R) Xeon(R) CPU E7440 reporting itself as model 29,
> and it runs without an issue.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Andi,

found this spec:

 http://www.intel.com/Assets/en_US/PDF/specupdate/320336.pdf

Please ack.

Thanks,

-Robert

> ---
>  arch/x86/oprofile/nmi_int.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 009b819..f1575c9 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -674,6 +674,7 @@ static int __init ppro_init(char **cpu_type)
>  	case 0x0f:
>  	case 0x16:
>  	case 0x17:
> +	case 0x1d:
>  		*cpu_type = "i386/core_2";
>  		break;
>  	case 0x1a:
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


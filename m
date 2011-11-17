Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1KQSjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:39:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41341 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab1KQSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:39:21 -0500
Message-ID: <4EC554CA.5070802@zytor.com>
Date: Thu, 17 Nov 2011 10:39:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/platform: (TS-5500) fix CONFIG_TS5500_ADC dependency
References: <1321555012-14331-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1321555012-14331-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 10:36 AM, Vivien Didelot wrote:
> Hi Ingo,
> 
> Here's the fix for the Kconfig dependency issue, for the TS-5500 platform.
> It is based on the latest x86/platform branch from the -tip tree.
> 
> Best,
> 
>     Vivien
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  arch/x86/platform/ts5500/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
> index be51b86..84e59a9 100644
> --- a/arch/x86/platform/ts5500/Kconfig
> +++ b/arch/x86/platform/ts5500/Kconfig
> @@ -23,6 +23,6 @@ config TS5500_LED
>  
>  config TS5500_ADC
>  	bool "TS-5500 ADC"
> -	depends on TS5500
> +	depends on TS5500 && HWMON=y
>  	help
>        Support for the A/D converter on Technologic Systems TS-5500 SBCs.

Shouldn't this be a module, too?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


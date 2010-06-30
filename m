Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0F3RIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:08:40 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:48629 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab0F3RIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:08:39 -0400
Date: Wed, 30 Jun 2010 20:07:31 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       Sandeep Paulraj <s-paulraj@ti.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Steve Chen <schen@mvista.com>, Cyril Chemparathy <cyril@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 02/33] Removing dead ARCH_DAVINCI_TNETV107X
Message-ID: <20100630170730.GE23534@tarshish>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Jun 30, 2010 at 06:05:38PM +0200, Christoph Egger wrote:
> ARCH_DAVINCI_TNETV107X doesn't exist in Kconfig, therefore removing
> all references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-davinci/include/mach/cputype.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/include/mach/cputype.h b/arch/arm/mach-davinci/include/mach/cputype.h
> index cea6b89..6143022 100644
> --- a/arch/arm/mach-davinci/include/mach/cputype.h
> +++ b/arch/arm/mach-davinci/include/mach/cputype.h
> @@ -85,10 +85,4 @@ IS_DAVINCI_CPU(tnetv107x, DAVINCI_CPU_ID_TNETV107X)
>  #define cpu_is_davinci_da850() 0
>  #endif
>  
> -#ifdef CONFIG_ARCH_DAVINCI_TNETV107X
> -#define cpu_is_davinci_tnetv107x() is_davinci_tnetv107x()
> -#else
> -#define cpu_is_davinci_tnetv107x() 0

Why remove the #else part?

baruch

> -#endif
> -
>  #endif
> -- 
> 1.7.0.4

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

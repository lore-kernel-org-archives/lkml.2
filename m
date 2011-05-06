Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1EFMEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:04:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:65332 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EFMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:04:48 -0400
Subject: Re: [PATCH] avr32: add some more at91 to cpu.h definition
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1304680123-20218-1-git-send-email-nicolas.ferre@atmel.com>
References: <1304680123-20218-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Fri, 06 May 2011 14:04:40 +0200
Message-ID: <1304683480.3025.2.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2011 12:04:41.0421 (UTC) FILETIME=[C7C9CFD0:01CC0BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 13:08 +0200, Nicolas Ferre wrote:
> Somme common drivers will need those at91 cpu_is_xxx() definitions.
> Those definitions are already in Linus' tree so if we want to use them
> in common drivers, we will need them in AVR32 cpu.h file.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Will you push this update for 2.6.39? I don't have anything for Linus
right now.

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
with one comment...

> ---
>  arch/avr32/mach-at32ap/include/mach/cpu.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
> index 9c96a13..a927d9e 100644
> --- a/arch/avr32/mach-at32ap/include/mach/cpu.h
> +++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
> @@ -31,8 +31,21 @@
>  #define cpu_is_at91sam9263()	(0)
>  #define cpu_is_at91sam9rl()	(0)
>  #define cpu_is_at91cap9()	(0)
> +#define cpu_is_at91cap9_revB()	(0)
> +#define cpu_is_at91cap9_revC()	(0)
>  #define cpu_is_at91sam9g10()	(0)
> +#define cpu_is_at91sam9g20()	(0)
>  #define cpu_is_at91sam9g45()	(0)
>  #define cpu_is_at91sam9g45es()	(0)
> +#define cpu_is_at91sam9m10()	(0)
> +#define cpu_is_at91sam9g46()	(0)
> +#define cpu_is_at91sam9m11()	(0)
> +#define cpu_is_at91sam9x5()	(0)
> +#define cpu_is_at91sam9g15()	(0)
> +#define cpu_is_at91sam9g35()	(0)
> +#define cpu_is_at91sam9x35()	(0)
> +#define cpu_is_at91sam9g25()	(0)
> +#define cpu_is_at91sam9x25()	(0)
> +

No need for this extra newline.

>  
>  #endif /* __ASM_ARCH_CPU_H */

-- 
Hans-Christian Egtvedt


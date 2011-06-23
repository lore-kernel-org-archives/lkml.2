Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab1FWXCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:02:07 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3828 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab1FWXCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:02:05 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E03C5E1.5090209@broadcom.com>
Date: Thu, 23 Jun 2011 16:01:53 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17)
 Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Jesper Juhl" <jj@chaosbits.net>
cc: LKML <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/37] Remove unneeded version.h includes from
 arch/arm/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106240007150.17688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106240007150.17688@swampdragon.chaosbits.net>
X-WSS-ID: 621D19685383548900-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/2011 3:08 PM, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in arch/arm/.
> This patch removes them.
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   arch/arm/mach-bcmring/irq.c   |    1 -
>   arch/arm/mach-bcmring/timer.c |    1 -
>   2 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
> index c48feaf..437fa68 100644
> --- a/arch/arm/mach-bcmring/irq.c
> +++ b/arch/arm/mach-bcmring/irq.c
> @@ -20,7 +20,6 @@
>   #include<linux/stddef.h>
>   #include<linux/list.h>
>   #include<linux/timer.h>
> -#include<linux/version.h>
>   #include<linux/io.h>
>
>   #include<mach/hardware.h>
> diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
> index 2d415d2..af9c3d7 100644
> --- a/arch/arm/mach-bcmring/timer.c
> +++ b/arch/arm/mach-bcmring/timer.c
> @@ -12,7 +12,6 @@
>   * consent.
>   *****************************************************************************/
>
> -#include<linux/version.h>
>   #include<linux/types.h>
>   #include<linux/module.h>
>   #include<csp/tmrHw.h>

Acked-by: Jiandong Zheng <jdzheng@broadcom.com>


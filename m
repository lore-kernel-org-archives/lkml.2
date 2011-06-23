Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537Ab1FWXC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:02:57 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3068 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab1FWXC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:02:56 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "JD (Jiandong) Zheng" <jdzheng@broadcom.com>
To: "Jesper Juhl" <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>
cc: "trivial@kernel.org" <trivial@kernel.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 23 Jun 2011 16:02:42 -0700
Subject: RE: [PATCH 07/37] Remove unneeded version.h includes from
 arch/arm/
Thread-Topic: [PATCH 07/37] Remove unneeded version.h includes from
 arch/arm/
Thread-Index: Acwx81nABuDixeQYSNqKC5Z4+2oABgABcX3g
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADF3FA9B8EB0@SJEXCHCCR02.corp.ad.broadcom.com>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106240007150.17688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106240007150.17688@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 621D18AA62O13214619-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
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



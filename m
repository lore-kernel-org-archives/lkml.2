Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0JADyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:54:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34386 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0JADyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:54:15 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "tony@atomide.com" <tony@atomide.com>
CC: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 30 Sep 2010 22:50:30 -0500
Subject: RE: [PATCH] scatterlist: define SG chain for arm architecture
Thread-Topic: [PATCH] scatterlist: define SG chain for arm architecture
Thread-Index: ActhFgZx7kpphIxCQ+S3J8G8W+ju9QABcTPB
Message-ID: <496565EC904933469F292DDA3F1663E602F3E074E0@dlee06.ent.ti.com>
References: <1285903354-7378-1-git-send-email-x0095840@ti.com>
In-Reply-To: <1285903354-7378-1-git-send-email-x0095840@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please discard this patch, it should have sent to linux-arm list.

Regards,
Fernando.

> 
> ________________________________________
> From: Guzman Lugo, Fernando
> Sent: Thursday, September 30, 2010 10:22 PM
> To: tony@atomide.com
> Cc: Hiroshi.DOYU@nokia.com; linux-kernel@vger.kernel.org; linux-omap@vger.ke
> rnel.org; Guzman Lugo, Fernando
> Subject: [PATCH] scatterlist: define SG chain for arm architecture
> 
> Define SG chain for ARM architecture in order to work
> with big buffers. This patch is needed in order to
> iovmm users can pass a big buffer to map it and ARM
> architecture has not issues using SG chain.
> 
> This change was suggested by FUJITA Tomonori.
> 
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  arch/arm/include/asm/scatterlist.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatt
> erlist.h
> index 2f87870..3de0a0b 100644
> --- a/arch/arm/include/asm/scatterlist.h
> +++ b/arch/arm/include/asm/scatterlist.h
> @@ -5,4 +5,6 @@
>  #include <asm/types.h>
>  #include <asm-generic/scatterlist.h>
> 
> +#define ARCH_HAS_SG_CHAIN
> +
>  #endif /* _ASMARM_SCATTERLIST_H */
> --
> 1.6.3.3
> 
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab1FFImX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:42:23 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:4274
	"EHLO CH1EHSOBE013.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752908Ab1FFImV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:42:21 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 6 Jun 2011 16:45:57 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/mxs: Fix build failure on ocotp.c
Message-ID: <20110606084555.GA21204@S2100-06.ap.freescale.net>
References: <20110606074024.23861.55150.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110606074024.23861.55150.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:40:38AM -0600, Grant Likely wrote:
> arch/arm/mach-mxs/ocotp.c needs to include asm/processor.h to get the
> definition of cpu_relax().
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/mach-mxs/ocotp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/ocotp.c b/arch/arm/mach-mxs/ocotp.c
> index 65157a3..c7a4d34 100644
> --- a/arch/arm/mach-mxs/ocotp.c
> +++ b/arch/arm/mach-mxs/ocotp.c
> @@ -16,6 +16,8 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  
> +#include <asm/processor.h>
> +
>  #include <mach/mxs.h>
>  
>  #define OCOTP_WORD_OFFSET		0x20
> 
> --

Wolfram had sent a fix for this.  But it has not hit the mainline.

https://patchwork.kernel.org/patch/815482/

-- 
Regards,
Shawn


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1ASJKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:10:08 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:56258 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab1ASJKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:10:07 -0500
MIME-Version: 1.0
In-Reply-To: <1295425166-25540-5-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de> <1295425166-25540-5-git-send-email-weber@corscience.de>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Wed, 19 Jan 2011 14:39:25 +0530
Message-ID: <AANLkTi=oWsKyAcDwpW-oO8nPM=vHOhJ8NGnFp4jjCGAL@mail.gmail.com>
Subject: Re: [PATCHv4 4/4] OMAP3: Devkit8000: Fix indentation of brace
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, sshtylyov@mvista.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 13:49, Thomas Weber <weber@corscience.de> wrote:
>
> Fix indentation of a closing curly brace.

As Manjunath mentioned for the other patch, I guess this patch can
also be merged
with some other patch in this series.

>
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 4ddd81c..a344cd8 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -553,7 +553,7 @@ static void __init omap_dm9000_init(void)
>                printk(KERN_ERR "Failed to request GPIO%d for dm9000 IRQ\n",
>                        OMAP_DM9000_GPIO_IRQ);
>                return;
> -               }
> +       }
>
>        gpio_direction_input(OMAP_DM9000_GPIO_IRQ);
>
> --
> 1.7.4.rc2
>

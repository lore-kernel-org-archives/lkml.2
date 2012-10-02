Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2JBKO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:14:27 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:1957
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab2JBKO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:14:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI1432I4015Izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB9GFU-02-556-02
X-M-MSG: 
Date: Tue, 2 Oct 2012 12:14:25 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: <paul.gortmaker@windriver.com>, <kubakici@wp.pl>,
        <stern@rowland.harvard.edu>, <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, <shuahkhan@gmail.com>
Subject: Re: [PATCH] dma-debug: Remove local BUS_NOTIFY_UNBOUND_DRIVER define
Message-ID: <20121002101425.GR4009@amd.com>
References: <1349117311.2688.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1349117311.2688.9.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:48:31PM -0600, Shuah Khan wrote:
> Remove local BUS_NOTIFY_UNBOUND_DRIVER define. This is not used since
> BUS_NOTIFY_UNBOUND_DRIVER is defined in include/linux/device.h
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  lib/dma-debug.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 66ce414..b9087bf 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -120,11 +120,6 @@ static const char *type2name[4] = { "single", "page",
>  static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
>  				   "DMA_FROM_DEVICE", "DMA_NONE" };
>  
> -/* little merge helper - remove it after the merge window */
> -#ifndef BUS_NOTIFY_UNBOUND_DRIVER
> -#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
> -#endif
> -

Thanks, applied.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


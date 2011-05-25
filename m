Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1EYSs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:48:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1EYSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:48:26 -0400
Date: Wed, 25 May 2011 20:48:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mainatiners: add dma engine tree details
Message-ID: <20110525184823.GC22361@pengutronix.de>
References: <1306346966-16385-1-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306346966-16385-1-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor note:

$subject ~= s/mainatiners/maintainers/

Best regards
Uwe

On Wed, May 25, 2011 at 11:39:26PM +0530, Koul, Vinod wrote:
> From: Vinod Koul <vinod.koul@intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8f44130..4435893 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2169,6 +2169,8 @@ M:	Dan Williams <dan.j.williams@intel.com>
>  S:	Supported
>  F:	drivers/dma/
>  F:	include/linux/dma*
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git
> +T:	git git://git.infradead.org/users/vkoul/slave-dma.git (slave-dma)
>  
>  DME1737 HARDWARE MONITOR DRIVER
>  M:	Juerg Haefliger <juergh@gmail.com>
> -- 
> 1.7.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

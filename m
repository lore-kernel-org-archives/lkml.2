Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HHOSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:18:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:23296 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1HHOSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,337,1309762800"; 
   d="scan'208";a="5097834"
Subject: Re: [RESEND][PATCH 0/2] mxs-dma: Bugfixes for mxs-dma originally
 sent in April
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        shawn.guo@freescale.com, u.kleine-koenig@pengutronix.de
In-Reply-To: <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
References: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
	 <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 19:47:19 +0530
Message-ID: <1312813039.1539.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 14:47 +0200, Lothar Waßmann wrote:
> Hi,
> 
> I'm resending two bugfixes for the mxs-dma driver, that I had
> originally sent in April which were acked by Shawn Guo and Uwe
> Kleine-König, but obviously were not picked up by any maintainer.
Sorry about that, in case you received ack on same patch you can carry
them when you resend.

Shawn, Uwe Kleine-König pls send your acks again, I will apply these

> 
> 
> Best regards,
> Lothar Waßmann
> ---
>  drivers/dma/mxs-dma.c |    3 ++-
>  drivers/dma/mxs-dma.c |   45 ++++++++++++++++++++++++---------------------
>  2 files changed, 26 insertions(+), 22 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod


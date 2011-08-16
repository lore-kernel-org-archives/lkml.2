Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1HPNMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:12:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:52434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1HPNMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:12:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,380,1309762800"; 
   d="scan'208";a="39004916"
Subject: Re: [RESEND][PATCH 0/2] mxs-dma: Bugfixes for mxs-dma originally
 sent in April
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        shawn.guo@freescale.com
In-Reply-To: <20110808162545.GV31521@pengutronix.de>
References: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
	 <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
	 <1312813039.1539.35.camel@vkoul-udesk3>
	 <20110808162545.GV31521@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 18:42:17 +0530
Message-ID: <1313500337.1603.101.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 18:25 +0200, Uwe Kleine-König wrote:
> On Mon, Aug 08, 2011 at 07:47:19PM +0530, Koul, Vinod wrote:
> > On Mon, 2011-08-08 at 14:47 +0200, Lothar Waßmann wrote:
> > > Hi,
> > > 
> > > I'm resending two bugfixes for the mxs-dma driver, that I had
> > > originally sent in April which were acked by Shawn Guo and Uwe
> > > Kleine-König, but obviously were not picked up by any maintainer.
> > Sorry about that, in case you received ack on same patch you can carry
> > them when you resend.
> > 
> > Shawn, Uwe Kleine-König pls send your acks again, I will apply these
> I'm sure I acked patch 1 and didn't look deeply into patch 2.

I have applied the patch 2/2. The patch 1/2 was no longer required as
its same as patch by Axel

commit 2a9778ed83b142e88cb38acc496a573a3472d27f
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Jul 12 18:53:52 2011 +0800

    dma: mxs-dma: fix unterminated platform_device_id table
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>



-- 
~Vinod


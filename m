Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2A3OCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:02:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:43559 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab2A3OCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:02:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112042732"
Subject: Re: [PATCH] fix starting of transfers in i.MX dma drivers
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACKLOr3tx0Kc8rZzx5sp91wCmDcjOB0byW0c7KrWT7VF1g2NyQ@mail.gmail.com>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
	 <1327914764.1527.15.camel@vkoul-udesk3>
	 <CACKLOr3tx0Kc8rZzx5sp91wCmDcjOB0byW0c7KrWT7VF1g2NyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 19:33:14 +0530
Message-ID: <1327932194.1527.43.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 13:22 +0100, javier Martin wrote:
> On 30 January 2012 10:12, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Mon, 2012-01-09 at 10:32 +0100, Sascha Hauer wrote:
> >> This moves the start of transfers from tx_submit to issue_pending
> >> for the i.MX dma drivers as requested by Vinoud here:
> >>
> >> https://lkml.org/lkml/2012/1/7/23
> >>
> >> This requires the users (mxcmmc and i.MX sound) to be fixed first.
> >> So Chris, Mark, given your Ack I would suggest to send this via
> >> Vinouds DMA tree.
> >>
> >> Sascha
> >>
> >> Sascha Hauer (4):
> >>       mmc: mxcmmc: add missing dma_async_issue_pending
> >>       ASoC: i.MX: Add missing dma_async_issue_pending
> >>       dma: imx-dma: start transfer in issue_pending
> >>       dma: imx-sdma: start transfer in issue_pending
> >>
> >>  drivers/dma/imx-dma.c           |    9 ++++-----
> >>  drivers/dma/imx-sdma.c          |   11 +++++------
> >>  drivers/mmc/host/mxcmmc.c       |    1 +
> >>  sound/soc/imx/imx-pcm-dma-mx2.c |    1 +
> >>  4 files changed, 11 insertions(+), 11 deletions(-)
> >
> > Thanks applied all.
> >
> > Fixed change log in 3 & 4, as Russell pointed out
> >
> > Got a conflict in 4, pls see that fix is right.
> 
> Hi Vinod,
> could you please tell me where has this been merged?
> 
> I can't see it at git://git.infradead.org/users/vkoul/slave-dma.git
> 
Sorry had forgot to push..... pushed now.


-- 
~Vinod


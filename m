Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1LUEtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:49:04 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:14375
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1LUEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:48:59 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Dec 2011 12:58:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Chris Ball <cjb@laptop.org>, Artem Bityutskiy <artem.bityutskiy@intel.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>, <linux-mtd@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
Message-ID: <20111221045805.GE5983@S2101-09.ap.freescale.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1324373044.1641.10096.camel@vkoul-udesk3>
 <20111220125401.GA5129@S2101-09.ap.freescale.net>
 <1324440424.1641.10104.camel@vkoul-udesk3>
 <20111221044517.GD5983@S2101-09.ap.freescale.net>
 <1324442451.1641.10109.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324442451.1641.10109.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 10:10:51AM +0530, Vinod Koul wrote:
> On Wed, 2011-12-21 at 12:45 +0800, Shawn Guo wrote:
> > > 
> > The term PIO here may not the one on your mind.  I call it 'mxs-dma
> > pio'.  In this mode, mxs-dma hardware can write values into mmc
> > controller register without cpu involved.
> what do you mean by values here?
> 
The register values that we want to write to mmc controller registers
in this case.

-- 
Regards,
Shawn


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1FFGto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:49:44 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:28526
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229Ab1FFGtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:49:43 -0400
X-SpamScore: -18
X-BigFish: VS-18(zz936eK179dN1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 6 Jun 2011 14:54:21 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <dan.j.williams@intel.com>,
        <patches@linaro.org>
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
Message-ID: <20110606065419.GA20904@S2100-06.ap.freescale.net>
References: <20110601023356.GA1501@S2100-06.ap.freescale.net>
 <20110605102855L.fujita.tomonori@lab.ntt.co.jp>
 <1307338118.10976.74.camel@vkoul-udesk3>
 <20110606153634D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110606153634D.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:38:12PM +0900, FUJITA Tomonori wrote:
> On Mon, 06 Jun 2011 10:58:38 +0530
> "Koul, Vinod" <vinod.koul@intel.com> wrote:
> 
> > On Sun, 2011-06-05 at 10:30 +0900, FUJITA Tomonori wrote:
> > > On Wed, 1 Jun 2011 10:33:57 +0800
> > > Shawn Guo <shawn.guo@freescale.com> wrote:
> > > 
> > > > On Thu, May 26, 2011 at 02:31:31PM +0800, Shawn Guo wrote:
> > > > > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > > > > max_segment_number into device_dma_parameters and creates the
> > > > > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > > > > 
> > > > > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > > > > ---
> > > > >  include/linux/device.h      |    1 +
> > > > >  include/linux/dma-mapping.h |   15 +++++++++++++++
> > > > >  2 files changed, 16 insertions(+), 0 deletions(-)
> > > 
> > > include/linux/dma-mapping.h is for DMA mapping API (please see
> > > Documentation/DMA-API*.txt).
> > > 
Hmm, I think they are all about dmaengine.

> > > What does dma_set(get)_max_seg_size do? And it's related with DMA
> > > mapping API?
> > See the other post by author
> 
> The pointer, please.
> 
http://permalink.gmane.org/gmane.linux.kernel/1149304

-- 
Regards,
Shawn


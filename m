Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1FFIGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:06:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:40780 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1FFIGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:06:19 -0400
Date: Mon, 6 Jun 2011 17:06:01 +0900
To: shawn.guo@freescale.com
Cc: fujita.tomonori@lab.ntt.co.jp, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, patches@linaro.org
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110606065419.GA20904@S2100-06.ap.freescale.net>
References: <1307338118.10976.74.camel@vkoul-udesk3>
	<20110606153634D.fujita.tomonori@lab.ntt.co.jp>
	<20110606065419.GA20904@S2100-06.ap.freescale.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110606163913U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Jun 2011 17:06:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 14:54:21 +0800
Shawn Guo <shawn.guo@freescale.com> wrote:

> On Mon, Jun 06, 2011 at 03:38:12PM +0900, FUJITA Tomonori wrote:
> > On Mon, 06 Jun 2011 10:58:38 +0530
> > "Koul, Vinod" <vinod.koul@intel.com> wrote:
> > 
> > > On Sun, 2011-06-05 at 10:30 +0900, FUJITA Tomonori wrote:
> > > > On Wed, 1 Jun 2011 10:33:57 +0800
> > > > Shawn Guo <shawn.guo@freescale.com> wrote:
> > > > 
> > > > > On Thu, May 26, 2011 at 02:31:31PM +0800, Shawn Guo wrote:
> > > > > > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > > > > > max_segment_number into device_dma_parameters and creates the
> > > > > > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > > > > > 
> > > > > > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > > > > > ---
> > > > > >  include/linux/device.h      |    1 +
> > > > > >  include/linux/dma-mapping.h |   15 +++++++++++++++
> > > > > >  2 files changed, 16 insertions(+), 0 deletions(-)
> > > > 
> > > > include/linux/dma-mapping.h is for DMA mapping API (please see
> > > > Documentation/DMA-API*.txt).
> > > > 
> Hmm, I think they are all about dmaengine.

No, I added them for the DMA mapping API (mainly, IOMMUs).

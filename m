Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1LFL7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:59:25 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54893 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933220Ab1LFL7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:59:24 -0500
Date: Tue, 6 Dec 2011 13:59:03 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        Rafal Prylowski <prylowski@metasoft.pl>
Subject: Re: [PATCH v2 1/2] dma/ep93xx_dma: fix initialization of M2M control
 register
Message-ID: <20111206115903.GA2695@mwesterb-mobl.ger.corp.intel.com>
References: <1bb25192ca6c0dc6f3631a3f937120d560e4e643.1322304185.git.mika.westerberg@iki.fi>
 <1323053309.30390.44.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323053309.30390.44.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 08:18:29AM +0530, Vinod Koul wrote:
> On Sat, 2011-11-26 at 12:54 +0200, Mika Westerberg wrote:
> > From: Rafal Prylowski <prylowski@metasoft.pl>
> > 
> > Setting the flags in case of IDE didn't have any effect since the control
> > register is overwritten few lines below. So move these to be after the control
> > register is initialized.
> > 
> > Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> > Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> > Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Applied both, Thanks
> 
> I got a trivial merge conflict on both patches as I think these patches
> were of made on top of dma_slave_direction changes we did sometime back.
> 
> So please do check if merges were right...

Looks right to me. Thanks.

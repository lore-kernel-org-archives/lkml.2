Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1DZEuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:50:19 -0400
Received: from 29.mail-out.ovh.net ([87.98.216.213]:55826 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751208Ab1DZEuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:50:17 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 00:50:17 EDT
Date: Tue, 26 Apr 2011 06:34:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/5] dmaengine: at_hdmac: modify way to use
 interrupts
Message-ID: <20110426043408.GG12904@game.jcrosoft.org>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
 <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
 <1303790574.896.11.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303790574.896.11.camel@vkoul-udesk3>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5581367314131430291
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:32 Tue 26 Apr     , Koul, Vinod wrote:
> On Fri, 2011-04-22 at 19:41 +0200, Nicolas Ferre wrote:
> > Now we use Buffer Transfer Completed interrupts. If we
> > want a chained buffer completed information, we setup the
> > ATC_IEN bit in CTRLB register in the lli.
> > This is done by set_desc_eol() function and used by
> > memcpy/slave_sg functions.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  drivers/dma/at_hdmac.c      |    4 ++--
> >  drivers/dma/at_hdmac_regs.h |   11 ++++++++---
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> >  
> Looks like your forgot to run checkpatch
> WARNING: line over 80 characters
> #401: FILE: drivers/dma/at_hdmac_regs.h:106:
> +#define MEM_IF			0		/* specify AHB interface 0 as memory interface */
> 
> WARNING: line over 80 characters
> #402: FILE: drivers/dma/at_hdmac_regs.h:107:
> +#define PER_IF			1		/* specify AHB interface 1 as peripheral interface
> */
> 
> WARNING: line over 80 characters
> #689: FILE: drivers/dma/at_hdmac.c:899:
> +			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> 
> total: 0 errors, 3 warnings, 465 lines checked
> 
> While I am okay with 3rd one, you can easily reformat code for first two
> and avoid these two warnings...
It's comments it make it more readable

Best Regards,
J.

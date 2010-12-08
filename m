Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0LHIkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:40:46 -0500
Received: from ip-87-86-252-34.easynet.co.uk ([87.86.252.34]:48464 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271Ab0LHIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:40:45 -0500
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 03:40:44 EST
Date: Wed, 8 Dec 2010 08:09:44 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jamie Iles <jamie@jamieiles.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Jamie Iles <jamie.iles@picochip.com>
Subject: Re: [PATCH 2/4] dmaengine/dw_dmac: allow src/dst masters to be
 configured at runtime
Message-ID: <20101208080944.GF7226@pulham.picochip.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
 <1290510371-23077-3-git-send-email-jamie@jamieiles.com>
 <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
 <1291790510.2794.1.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291790510.2794.1.camel@hcegtvedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Wed, 08 Dec 2010 08:09:46 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 06:41:50AM +0000, Hans-Christian Egtvedt wrote:
> On Tue, 2010-12-07 at 17:03 -0800, Dan Williams wrote: 
> > [ adding Hans ]
> > 
> > On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> > > Some platforms have flexible mastering capabilities and this needs
> > > to be selected at runtime. If the platform has specified private
> > > data in the form of the dw_dma_slave then fetch the source and
> > > destination masters from here. If this isn't present, default to
> > > the previous of 0 and 1.
> > >
> > > Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> > > ---
> > 
> > Hi James,
> > 
> > Please integrate checkpatch into your workflow and fixup the trivial
> > whitespace damage (tabs-to-spaces) reports.
> > 
> > Also noticed this on patch 1/4 of this series.
> > 
> > Hans, can you provide an acked-by for this series when James reposts it?
> 
> The arch stuff, or the DMA stuff? I do not track DMA changes, so I don't
> think my acked-by would be very valuable.
> 
> I didn't see any updated arch patches, was I supposed to see that?
No, it was just the dmaengine patches that were updated for whitespace. The 
avr32 patch is untouched.

Thanks,

Jamie

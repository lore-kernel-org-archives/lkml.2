Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2JDMy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:54:29 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59712 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2JDMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:54:26 -0400
Date: Thu, 4 Oct 2012 08:54:55 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/6] ARM: davinci: da850-dm646x: remove the SRAM_VIRT
 iotable entry
Message-ID: <20121004125455.GE11149@beef>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <1349276133-26408-3-git-send-email-mporter@ti.com>
 <506D78BE.1000607@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D78BE.1000607@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 05:23:34PM +0530, Sekhar Nori wrote:
> On 10/3/2012 8:25 PM, Matt Porter wrote:
> > From: Ben Gardiner <bengardiner@nanometrics.ca>
> > 
> > The sram regions defined for da850-dm646x in their iotable entries are also
> > defined in their davinci_soc_info's.
> > 
> > Remove this duplicate information which is now uneccessary since sram
> > init will ioremap the regions defined by their davinci_soc_info's.
> > 
> > Since this removal completely removes all uses of SRAM_VIRT, also remove
> > the SRAM_VIRT definition.
> > 
> > Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> > Tested-by: Matt Porter <mporter@ti.com>
> 
> What testing was done with this patch? Can you please add that
> information to the commit text as well.

I have only tested on AM180x with uio_pruss and davinci-pcm (series
for that posted a short while ago). In the uio_pruss case, I run the
sample applications from the userspace PRU package that test
communication with the shared SRAM, DDR, and internal PRU SRAM. For
davinci-pcm, my series enables shared SRAM ping-pong buffering which is
working comparably to pcm capture/playback without ping-pong buffering
enabled on AM180x.

I have not tested PM at all...yet.

I'll add this detail to the commit.

-Matt

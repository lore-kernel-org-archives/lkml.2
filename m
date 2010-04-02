Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0DBLo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:44:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47974 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932293Ab0DBLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:44:50 -0400
Date: Fri, 2 Apr 2010 12:44:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add WM8994 interrupt controller support
Message-ID: <20100402114448.GB32467@rakim.wolfsonmicro.main>
References: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100330141201.GA17007@sirena.org.uk>
 <20100402101754.GD8010@sortiz.org>
 <20100402102422.GA32467@rakim.wolfsonmicro.main>
 <20100402113027.GF8010@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402113027.GF8010@sortiz.org>
X-Cookie: WYSIWYG:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 01:30:28PM +0200, Samuel Ortiz wrote:

> > The bulk of the code using these interrupts will be the
> > CODEC driver for the device, but the CODEC driver needs to be able to
> > check if interrupts are set up at all (since commonly CODECs don't have
> > an IRQ line wired up) so it'd be nice if it were possible to merge via
> > ASoC.

> I'm fine with that, please carry this patch. During the next merge window I'll
> wait for your code to be merged upstream, fix any potential merge conflicts
> and send my pull request.

Thanks.  I'd expect that if things are fine in -next you can probably
not worry about this either way, but given that Takashi normally sends
his pull request very early it probably won't make any difference
anyway.

> Also, I had a look at the code and feel free to add my:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> to it.
> 
> Cheers,
> Samuel.
> 
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab2C3KoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:44:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57500 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab2C3KoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:44:06 -0400
Date: Fri, 30 Mar 2012 11:43:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120330104354.GD22981@n2100.arm.linux.org.uk>
References: <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange> <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com> <Pine.LNX.4.64.1203161128120.13465@axis700.grange> <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com> <Pine.LNX.4.64.1203161522570.13465@axis700.grange> <20120330102910.GB22981@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203301236330.24548@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203301236330.24548@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:40:12PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 30 Mar 2012, Russell King - ARM Linux wrote:
> 
> > On Fri, Mar 16, 2012 at 03:28:39PM +0100, Guennadi Liakhovetski wrote:
> > > Yessss!!! Let's do that! :-D Now, you're proposing exactly the same, as 
> > > what I was proposing! :-) Now you just have to remove the filter function 
> > > parameter from dma_request_channel() - it is anyway the same for all and 
> > > implemented in the dmaengine core - and you get
> > > 
> > > dma_request_channel(mask, slave_desc)
> > > 
> > > which is exactly what I was proposing! :-)
> > 
> > Bollocks it is.  You're wanting to use the peripheral address, width
> > and burst size to try to determine what channel to use.  That's a
> > totally crackpot idea, and as I've already said several times it won't
> > work in many real life cases we have already.
> 
> I'm afraid I'm just somehow failing to explain my thoughts to you, 
> Russell. I don't think I ever said about using addresses, widths etc.

Not directly - what you said was about combining the request functionality
along with the slave_config functionality.  The slave_config functionality
takes exactly what I said above: the addresses, widths, burst size of the
peripheral.

Therefore, you did _by implication of what the functions you have been
referring to do_ been talking exactly about using addresses, widths and
burst sizes to select the channel.

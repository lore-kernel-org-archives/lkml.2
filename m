Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2ADTGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35553 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2ADTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:26 -0500
Date: Wed, 4 Jan 2012 11:24:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20120104182410.GT15503@ponder.secretlab.ca>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
 <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
 <20120102132500.GB18443@sirena.org.uk>
 <CACRpkdYxjVG2XVb5iXPmVe5uTcpemBkOA-=AcuyNx-9cWPpaiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYxjVG2XVb5iXPmVe5uTcpemBkOA-=AcuyNx-9cWPpaiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 02:48:40PM +0100, Linus Walleij wrote:
> On Mon, Jan 2, 2012 at 2:25 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Mon, Jan 02, 2012 at 12:53:16PM +0000, Jamie Iles wrote:
> >> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> >> and can be configured to provide multiple banks of GPIO pins.
> >>
> >> v3:   - depend on rather than select IRQ_DOMAIN
> >>       - split IRQ support into a separate patch
> >> v2:   - use Rob Herring's irqdomain in generic irq chip patches
> >>       - use reg property to indicate bank index
> >>       - support irqs on both edges based on LinusW's u300 driver
> >
> > Put stuff like this after the ---, it shouldn't end up in git history.
> 
> The other day I was being told the exact opposite by Grant
> Likely, so which one is it?

It's the preference of whatever maintainer will actually be picking up
the patch.  :-)  There is no definitive answer.

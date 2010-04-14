Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0DNHbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:31:43 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:46502 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DNHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:31:41 -0400
Date: Wed, 14 Apr 2010 09:31:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>, linux-kernel@vger.kernel.org,
       amit.kucheria@canonical.com, linux@arm.linux.org.uk,
       grant.likely@secretlab.ca, Herring Robert-RA7055 <RA7055@freescale.com>,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 1/8] mx5: Add registration of GPIOs for MX51
 Babbage board.
Message-ID: <20100414073138.GZ30801@buzzloop.caiaq.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
 <20100413164532.GM30801@buzzloop.caiaq.de>
 <86A0E76937111F4C92FABEC0A2098851046C7A62@az33exm21>
 <20100414065131.GD7882@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414065131.GD7882@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 08:51:31AM +0200, Sascha Hauer wrote:
> On Tue, Apr 13, 2010 at 12:36:07PM -0700, Nguyen Dinh-R00091 wrote:
> > > +
> > > +#ifdef MXC_GPIO_SPLIT_IRQ_2
> > 
> > Where is that macro defined?
> > [Dinh-FSL] - This macro is optional so that the interrupts can be broken
> > up into 2 sets.
> 
> What's the purpose of doing so?
> 
> Such compile time depencies are not a good idea since the board may want
> to decide whether to split the interrupts or not. Note that we support
> kernels for more than one board.

And I would have expected at least one active user. As it stands, it's
just dead code.

Daniel

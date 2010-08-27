Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0H0NDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:03:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57519 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0H0NDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:03:50 -0400
Subject: RE: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Gary King <GKing@nvidia.com>
Cc: Mike Rapoport <mike@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <A0A1E7539300DF49AA383E614C7827BC04EA05BE3A@HQMAIL01.nvidia.com>
References: <1282487895.23014.19.camel@phoenix>
	 <1282488162.23014.24.camel@phoenix>
	 <20100823100248.GG6061@rakim.wolfsonmicro.main>
	 <4C7248C3.9040304@compulab.co.il>,<1282730014.2991.155.camel@odin>
	 <A0A1E7539300DF49AA383E614C7827BC04EA05BE3A@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 14:03:44 +0100
Message-ID: <1282914224.3025.28.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 14:25 -0700, Gary King wrote:
> The patch seems fine.
> 
> - Gary
> ________________________________________
> From: Liam Girdwood [lrg@slimlogic.co.uk]
> Sent: Wednesday, August 25, 2010 2:53 AM
> To: Mike Rapoport
> Cc: Mark Brown; Gary King; Axel Lin; linux-kernel
> Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask parameter for tps6586x_set_bits()
> 
> On Mon, 2010-08-23 at 13:09 +0300, Mike Rapoport wrote:
> > Mark Brown wrote:
> > > On Sun, Aug 22, 2010 at 10:42:42PM +0800, Axel Lin wrote:
> > >> The third parameter of tps6586x_set_bits() is the bit_mask,
> > >> thus we should use (1 << ri->go_bit) instead of ri->go_bit.
> > >>
> > >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > >
> > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > >
> > > but I'd be much happier if someone who actually has the hardware could
> > > verify that this is OK.
> >
> > I don't have the hardware handy at the moment.
> > Gary, can you please verify the fix?
> >
> 
> Do we have any news on this testing ? I'd like to have these upstream
> for rc3.
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


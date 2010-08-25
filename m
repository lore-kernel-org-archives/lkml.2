Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0HYJxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:53:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0HYJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:53:45 -0400
Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Gary King <gking@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7248C3.9040304@compulab.co.il>
References: <1282487895.23014.19.camel@phoenix>
	 <1282488162.23014.24.camel@phoenix>
	 <20100823100248.GG6061@rakim.wolfsonmicro.main>
	 <4C7248C3.9040304@compulab.co.il>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 10:53:34 +0100
Message-ID: <1282730014.2991.155.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 13:09 +0300, Mike Rapoport wrote: 
> Mark Brown wrote:
> > On Sun, Aug 22, 2010 at 10:42:42PM +0800, Axel Lin wrote:
> >> The third parameter of tps6586x_set_bits() is the bit_mask,
> >> thus we should use (1 << ri->go_bit) instead of ri->go_bit.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > but I'd be much happier if someone who actually has the hardware could
> > verify that this is OK.
> 
> I don't have the hardware handy at the moment.
> Gary, can you please verify the fix?
> 

Do we have any news on this testing ? I'd like to have these upstream
for rc3.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


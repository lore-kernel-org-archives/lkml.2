Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0HZV0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:26:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7860 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0HZV0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:26:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 26 Aug 2010 14:26:36 -0700
From: Gary King <GKing@nvidia.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 26 Aug 2010 14:25:44 -0700
Subject: RE: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
Thread-Topic: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
Thread-Index: ActEO28ms/pL8g0kRCOaYwxvbElFugBKc7sy
Message-ID: <A0A1E7539300DF49AA383E614C7827BC04EA05BE3A@HQMAIL01.nvidia.com>
References: <1282487895.23014.19.camel@phoenix>
	 <1282488162.23014.24.camel@phoenix>
	 <20100823100248.GG6061@rakim.wolfsonmicro.main>
	 <4C7248C3.9040304@compulab.co.il>,<1282730014.2991.155.camel@odin>
In-Reply-To: <1282730014.2991.155.camel@odin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch seems fine.

- Gary
________________________________________
From: Liam Girdwood [lrg@slimlogic.co.uk]
Sent: Wednesday, August 25, 2010 2:53 AM
To: Mike Rapoport
Cc: Mark Brown; Gary King; Axel Lin; linux-kernel
Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask parameter for tps6586x_set_bits()

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


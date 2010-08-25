Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0HYQEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:04:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8377 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0HYQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:04:04 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 12:04:04 EDT
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 25 Aug 2010 08:58:47 -0700
From: Gary King <GKing@nvidia.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Mike Rapoport <mike@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 25 Aug 2010 08:58:42 -0700
Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
Thread-Topic: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
Thread-Index: ActEbmaiT0KPH5isTJy5sSmt94tIzQ==
Message-ID: <4C753DB2.3070103@nvidia.com>
References: <1282487895.23014.19.camel@phoenix>
	 <1282488162.23014.24.camel@phoenix>
	 <20100823100248.GG6061@rakim.wolfsonmicro.main>
	 <4C7248C3.9040304@compulab.co.il> <1282730014.2991.155.camel@odin>
In-Reply-To: <1282730014.2991.155.camel@odin>
Reply-To: Gary King <GKing@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11)
 Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7PG4Wsg002221

Sorry, I must have missed the original e-mail.

I'll give it a try either later today or tomorrow, after I 
context-switch back to my dev system that uses the tps6586x driver.

- Gary

On 08/25/2010 02:53 AM, Liam Girdwood wrote:
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
> Thanks
>
> Liam
> --
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0JBNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:22:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57084 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0JBNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:22:36 -0400
Subject: Re: [PATCH] regulator: max8649 - fix setting extclk_freq
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
In-Reply-To: <20101001173643.GB21157@opensource.wolfsonmicro.com>
References: <1285912587.12422.2.camel@mola>
	 <20101001071906.GC20529@opensource.wolfsonmicro.com>
	 <AANLkTi=4Bv72d56XU+4jXZ8wHp+R_1VfaKOrvp_PtG4M@mail.gmail.com>
	 <20101001173643.GB21157@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 14:22:33 +0100
Message-ID: <1286025753.3125.25.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 10:36 -0700, Mark Brown wrote:
> On Fri, Oct 01, 2010 at 07:18:14PM +0800, Axel Lin wrote:
> > 2010/10/1 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> 
> > > Are there existing users of the driver?  It's not always 100% clear if
> > > people are expecting bitfield values that will be shifted in or values
> > > that can be ored directly in.  I don't really mind either way but I'd
> > > rather be careful.
> 
> > I think I should explain this way:
> 
> > In max8649.h , we have
> > enum {
> >         MAX8649_EXTCLK_26MHZ = 0,
> >         MAX8649_EXTCLK_13MHZ,
> >         MAX8649_EXTCLK_19MHZ,   /* 19.2MHz */
> > };
> 
> OK, that's clearer.  When changing the interpretation of existing
> platform data like this it's good to note this sort of thing in the
> changelog since merge issues can be a real pain.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


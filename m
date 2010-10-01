Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0JARga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:36:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58621 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345Ab0JARg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:36:29 -0400
Date: Fri, 1 Oct 2010 10:36:44 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: max8649 - fix setting extclk_freq
Message-ID: <20101001173643.GB21157@opensource.wolfsonmicro.com>
References: <1285912587.12422.2.camel@mola>
 <20101001071906.GC20529@opensource.wolfsonmicro.com>
 <AANLkTi=4Bv72d56XU+4jXZ8wHp+R_1VfaKOrvp_PtG4M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=4Bv72d56XU+4jXZ8wHp+R_1VfaKOrvp_PtG4M@mail.gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 07:18:14PM +0800, Axel Lin wrote:
> 2010/10/1 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > Are there existing users of the driver?  It's not always 100% clear if
> > people are expecting bitfield values that will be shifted in or values
> > that can be ored directly in.  I don't really mind either way but I'd
> > rather be careful.

> I think I should explain this way:

> In max8649.h , we have
> enum {
>         MAX8649_EXTCLK_26MHZ = 0,
>         MAX8649_EXTCLK_13MHZ,
>         MAX8649_EXTCLK_19MHZ,   /* 19.2MHz */
> };

OK, that's clearer.  When changing the interpretation of existing
platform data like this it's good to note this sort of thing in the
changelog since merge issues can be a real pain.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

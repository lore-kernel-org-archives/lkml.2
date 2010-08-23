Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0HWHa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 03:30:26 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:47702 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab0HWHaZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 03:30:25 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Date: Mon, 23 Aug 2010 09:30:06 +0200
Subject: RE: [PATCH] MFD: Align AB8500 with the abx500.h interface
Thread-Topic: [PATCH] MFD: Align AB8500 with the abx500.h interface
Thread-Index: ActBGVTC83zYcadWTv+3z6rZyapXUgBe2HJw
Message-ID: <CEE6BB42CAD6E947908279175AF8470A026AEC6DED@EXDCVYMBSTM006.EQ1STM.local>
References: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
 <20100821101213.GC5545@opensource.wolfsonmicro.com>
In-Reply-To: <20100821101213.GC5545@opensource.wolfsonmicro.com>
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

[Mark]

> Subject: Re: [PATCH] MFD: Align AB8500 with the abx500.h interface
> (...)
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks Mark!

> >  static struct mfd_cell ab8500_devs[] = {
> > +#ifdef CONFIG_DEBUG_FS
> > +	{
> > +		.name = "ab8500-debug",
> > +	},
> > +#endif
> 
> This one looks like it slipped in from a separate change, though?

Yeahm,  it doesn't hurt och break git-bisect but if it's disturbing
I can spin it over to the other patch.

Right now I'm just awaiting Sams reply to if he wants per-subsystem
patches or not, so I'll make a final version if there are more
changes required.

Yours,
Linus Walleij

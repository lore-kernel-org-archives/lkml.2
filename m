Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab0JZJNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:13:45 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43910 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0JZJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:13:43 -0400
Date: Tue, 26 Oct 2010 11:13:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Ralf Baechle" <ralf@linux-mips.org>, <linux-i2c@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
Message-ID: <20101026111322.738b0b14@endymion.delvare>
In-Reply-To: <001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com>
References: <4CC645A1.5010509@dsn.okisemi.com>
	<20101026102048.316d0c04@endymion.delvare>
	<001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 18:05:07 +0900, Tomoya MORINAGA wrote:
> On Tuesday, October 26, 2010 5:20 PM, Jean Delvare wrote:
> 
> > I don't like this driver name at all. For one thing, "pch" is too
> > short. Many other vendors could come up with names with acronym "PCH".
> >
> > For another, Intel has many PCH (Platform Controller Hub) chips, some
> > of them (5/3400 Series, Cougar Point, Patsburg) are or will be
> > supported by the i2c-i801 driver, some of them (Moorestown) will be
> > supported by the upcoming i2c-intel-mid driver (even though the name
> > "PCH" is surprisingly missing from the source code) and your driver
> > only supports one particular model.
>
> Yes, this driver suppors only Topcliff(Intel Atom E6xx series) now.
>
> > So please find a name which accurately represents the hardware your
> > driver is for. i2c-topcliff would be fine with me, but you will have to
> > check with Intel, as I know they are quite picky with the usage of code
> > names.
> 
> Most drivers for Topcliff have been accepted with "pch_" prefix.

If other maintainers like their subsystem to be messy and confusing, up
to them ;)

> Only SPI driver, like you indicates, have accepted as spi_topcliff_pch.c.
> If you request,  I can modify "pch_i2c.c" to "i2c-topcliff_pch.c".

The _pch becomes redundant then, i2c-topcliff.c would be enough, but
both are fine with me, as my initial concern is gone.

> > As for the driver code, I will not be able to review it, sorry. It's
> > not in my area, I don't have the time and I don't have the hardware. I
> > think it would make sense for Intel people to review and test it before
> > it gets upstream.
>
> No problem!
> After reviewing by Intel(:CCed), we started posting to LKML and
> we have already tested this patch on the EVA Board.
> 
> Tuhs, I want you to merge to this patch to 2.6.37 ASAP.

There's no Reviewed-by, Acked-by or Signed-off-by from anyone at Intel
in the patch you posted. Which, as far as I am concerned, means that
nobody at Intel looked at the code so far. If this is incorrect, please
resend the patch with the appropriate acknowledgments and driver
history, so that it is clearer, who did what.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0IWKyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:54:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44317 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752651Ab0IWKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:54:40 -0400
Date: Thu, 23 Sep 2010 11:54:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923105438.GE25663@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
 <20100923114845.1938d9dc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100923114845.1938d9dc@lxorguk.ukuu.org.uk>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:48:45AM +0100, Alan Cox wrote:
> > any of this code could ever be made generic.  The spec seems to only
> > cover the data structure, and relationships between devices seem to be
> > left to whatever convention the firmware writer feels like using, or
> > am I missing something?

> Not really no. It's basically little more than a component and IRQ list.
> The GPIO table in 0.8 exposes the GPIO lines a bit more sanely.

> In fact all that SFI provides generically pretty much fits into
> platform_foo() already because there is so little - or into the I²C or
> SPI bus data.

I believe the issue here is the handling of things where the
functionality Linux needs is implemented over multiple chips so we need
a way for the chips to find each other.

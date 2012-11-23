Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2KWLfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:35:12 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:34790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2KWLfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:35:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Fri, 23 Nov 2012 12:39:40 +0100
Message-ID: <1717408.oqDbQt79dV@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121121225450.026dcaf6@endymion.delvare>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <79636467.nuLQX2FqW5@vostro.rjw.lan> <20121121225450.026dcaf6@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 21, 2012 10:54:50 PM Jean Delvare wrote:
> On Wed, 21 Nov 2012 22:31:15 +0100, Rafael J. Wysocki wrote:
> > > Mathias Nyman (1):
> > >   gpio / ACPI: add ACPI support
> > > 
> > > Mika Westerberg (2):
> > >   spi / ACPI: add ACPI enumeration support
> > >   i2c / ACPI: add ACPI enumeration support
> > 
> > This patchset has been around for quite a while and went through a few
> > iterations, so I think it's as good as it gets at this point.
> > 
> > I wonder if the GPIO / SPI / I2C maintainers have any objections against it or
> > would like the patches to be modified somehow?
> 
> I'd say go ahead, any issue that shows up can be fixed afterward.
> 
> > If not, then I'd like to take it for v3.8 into the linux-pm.git tree, because
> > the patches depend on some changes already in that tree.  Hopefully, that's OK.
> 
> Yes.

Cool, thanks! :-)

I took the i2c patch for linux-next (targeting v3.8) and I'm waiting with
the GPIO and SPI patches for a word from Grant.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

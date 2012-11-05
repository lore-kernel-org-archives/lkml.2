Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2KEJVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:21:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:64378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2KEJVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:21:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,713,1344236400"; 
   d="scan'208";a="244218488"
Date: Mon, 5 Nov 2012 11:23:45 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3] ACPI 5 support for GPIO, SPI and I2C
Message-ID: <20121105092345.GB24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb0jmiBBi+W0U7h5PfVF-kYP+Ui-nOzWxBazMHxupruwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb0jmiBBi+W0U7h5PfVF-kYP+Ui-nOzWxBazMHxupruwA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 07:29:10PM +0100, Linus Walleij wrote:
> On Sat, Nov 3, 2012 at 8:46 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > With ACPI 5 we can now describe how devices are connected to their bus
> > using new resources: SPISerialBus and I2CSerialBus. Also it is now possible
> > to add GPIO connections for the devices with the help of GpioIO and GpioInt
> > resources.
> >
> > This series adds support for these new resources.
> 
> I would very much like Grant to review and merge these patches, since he
> is way more familiar with these concepts than me, but I'll have a quick
> glance for syntax and semantics...

That sounds good, thanks!

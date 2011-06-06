Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1FFPRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:17:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52480 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1FFPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:17:00 -0400
Date: Mon, 6 Jun 2011 16:15:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110606151504.GA7448@n2100.arm.linux.org.uk>
References: <20110605071725.26517.11573.stgit@ponder> <201106061100.38249.arnd@arndb.de> <BANLkTi=XoD8RiiEihB5bC1Zogxo+J7o3Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=XoD8RiiEihB5bC1Zogxo+J7o3Qg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 08:39:04AM -0600, Grant Likely wrote:
> However, there are a number of bus types that have infrastructure, but
> no actual drivers associated with them, like mca, amba and clk.  It
> might make sense to move those bus types into drivers/base alongside
> the platform_bus_type implementation.

More or less agreed - I'm not sure we should think about clk just yet
because we don't know what that'll end up looking like yet...

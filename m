Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2IUSOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:14:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49619 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2IUSOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120920213636.2ee27d41@skate>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<50559737.8000705@gmail.com>
	<CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
	<201209201530.40974.arnd@arndb.de>
	<CACRpkdZYr2B83e3mBmMkO8Ai3xU_QGevfbSOSNoTvK3Lz6y6mg@mail.gmail.com>
	<20120920213636.2ee27d41@skate>
Date: Fri, 21 Sep 2012 20:14:20 +0200
Message-ID: <CACRpkdYGjen9xVHHK0ca-4z4uFbuLZq1iJuuUsFssF3Ec4Kx8g@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 9:36 PM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:

> If I understand correctly, we would like drivers to be able to read
> some common "system" registers to figure out which SoC variant we are
> running on. Such feature should normally be provided by code in
> arch/arm/mach-*/ and called by drivers, but we are trying to eliminate
> all dependencies of driver code on architecture code, correct?

So what I think is that any such mechanism would defy the idea
with device tree providing all platform configuration, including
the ASIC/SoC variant.

The only not-so-unelegant idea I have is for the machine to
go in and fiddle with the device tree, e.g. add some info into
the tree somewhere stating into the nodes which ASIC variant
it is. Maybe even modify the compatible value at runtime.

But it somehow feels like cracking an egg with a sledgehammer.

I think we need to meditate on this.

Yours,
Linus Walleij

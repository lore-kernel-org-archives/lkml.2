Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1FJKqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:46:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57144 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1FJKqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:46:17 -0400
Date: Fri, 10 Jun 2011 11:45:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        alan@lxorguk.ukuu.org.uk, kumar.gala@freescale.com,
        benh@kernel.crashing.org, greg@kroah.com, akpm@kernel.org,
        cmetcalf@tilera.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
	management driver
Message-ID: <20110610104551.GB26441@sirena.org.uk>
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <201106092213.13755.arnd@arndb.de> <4DF12A94.6070605@freescale.com> <201106092233.08030.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106092233.08030.arnd@arndb.de>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:33:07PM +0200, Arnd Bergmann wrote:
> On Thursday 09 June 2011 22:18:28 Timur Tabi wrote:

> > Ok, I was really hoping to avoid doing this.  Like I said, binary compatibility
> > is important, and changing the type will break my existing apps.  Are you
> > insisting that I pick a new number?

> I definitely insist that you have a proper interface in the driver at the
> time that it gets merged, and that probably includes a collision-free
> ioctl code.

This sort of stuff is one of the issues that should be being factored in
to any decision not to publish and submit the kernel code - ABIs that
haven't been reviewed upstream may well have this sort of issue.

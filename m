Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0GLRc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:32:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36842 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0GLRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:32:54 -0400
Date: Mon, 12 Jul 2010 18:32:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM defconfig files
Message-ID: <20100712173228.GC9897@n2100.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org> <20100614083214.GA2104@pengutronix.de> <20100630104043.GG11746@pengutronix.de> <20100712155518.GA24144@pengutronix.de> <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 09:51:47AM -0700, Linus Torvalds wrote:
> So if the ARM people decide that your script is a good way to clean up
> the mess, I might be happy with that. But that would require that they
> NEVER EVER try to push me a update that contains an un-cleaned-up
> defconfig file.

Does this mean that you aren't going to delete all the defconfigs
during the next merge window if we come up with an alternative
solution to yours?

When you brought up the problem you seemed absolutely convinced
that nothing except your solution was going to be acceptable.

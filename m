Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1GLIdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:33:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45571 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1GLIdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:33:09 -0400
Date: Tue, 12 Jul 2011 09:32:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: fix regression in IXP4xx clocksource
Message-ID: <20110712083252.GC23270@n2100.arm.linux.org.uk>
References: <m3liwb15t2.fsf@intrepid.localdomain> <20110712080513.GA2937@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712080513.GA2937@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:05:13AM +0200, Richard Cochran wrote:
> On Wed, Jul 06, 2011 at 11:02:17PM +0200, Krzysztof Halasa wrote:
> > From: Richard Cochran <richardcochran@gmail.com>
> > 
> > Commit 234b6ceddb4fc2a4bc5b9a7670f070f6e69e0868
> > 
> >    clocksource: convert ARM 32-bit up counting clocksources
> > 
> > broke the build for ixp4xx and made big endian operation impossible.
> > This commit restores the original behaviour.
> 
> I know I nag, but can we *please* have this patch in 3.0?
> Big endian IXP really, really does not work without it.

Thomas Glexnier said:
> Thinking more about it we should add BE accessor functions to the mmio
> clocksource as this might be useful for other architectures as well.

It seems that I can't rely on others, so I'm going to have to fit
this into my busy schedule at some point.

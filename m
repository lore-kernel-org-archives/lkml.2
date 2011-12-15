Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab1LOFAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:00:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56667 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1LOFAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:00:13 -0500
Date: Thu, 15 Dec 2011 05:00:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Axel Lin <axel.lin@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-next] make  s5p64x0_defconfig build error
Message-ID: <20111215050005.GA24287@sirena.org.uk>
References: <1323838630.18517.1.camel@phoenix>
 <20111214123244.GE7122@mudshark.cambridge.arm.com>
 <20111214191205.GF14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214191205.GF14542@n2100.arm.linux.org.uk>
X-Cookie: Not recommended for children.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 07:12:05PM +0000, Russell King - ARM Linux wrote:
> On Wed, Dec 14, 2011 at 12:32:44PM +0000, Will Deacon wrote:

> >     ARM: restart: Temporary #error to persuade platform maintainers to take the restart changes seriously

> >     Force builds to fail to ensure that platform maintainers take the
> >     restart changes seriously, and sort out fixing their code before the
> >     next merge window.

> Indeed, and note the date, and how long its taken for just one of the
> platforms to be noticed.

I noticed s3c64xx the day you added that change but just deleted the
code so I could carry on working after my initial attempts to figure out
what this was about took too long.

> It seems to me that no one really cares about whether six of the seven
> platforms which have the #error build or don't build, so I really think
> there's a simple solution to this at the next merge window - delete any
> platform which hasn't _at_ _least_ responded with a proposed patch to
> this.

Do you have any references to this stuff?  I did make some effort to
understand what needed to be done but the patch doesn't mention which
restart changes are needed and my grovelling around in git wasn't
turning up enough context to tell me what was supposed to be happening
instead.  Frankly I've no need for that code in my systems so if it's a
problem I'd just throw the restart code away if it was that or breakage.

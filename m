Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0I1EhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:37:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38426 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0I1EhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:37:16 -0400
Date: Tue, 28 Sep 2010 05:37:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
	default
Message-ID: <20100928043704.GA7455@sirena.org.uk>
References: <1284111212-10659-1-git-send-email-florian@mickler.org> <1285527125.1732.24.camel@Joe-Laptop> <20100927165748.354742f2@schatten.dmk.lab> <20100927154441.GE3602@thunk.org> <20100927190026.20ddc268@schatten.dmk.lab> <20100927182124.GA3168@thunk.org> <20100927212650.62859ee0@schatten.dmk.lab> <1285618097.1732.204.camel@Joe-Laptop> <20100927204756.GC3168@thunk.org> <1285622205.4725.34.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285622205.4725.34.camel@Joe-Laptop>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:16:45PM -0700, Joe Perches wrote:
> On Mon, 2010-09-27 at 16:47 -0400, Ted Ts'o wrote:

> Mark Brown said: http://lkml.org/lkml/2010/9/10/116
> ----------------------------------------------------
> On Fri, Sep 10, 2010 at 03:04:26AM -0700, Joe Perches wrote:

> > It'd be great if the ARM/embedded folk would spend
> > some effort improving the MAINTAINERS file pattern
> > coverage.

> Half the problem is that a lot of drivers aren't maintained by the
> people who wrote them - for example, they wrote the driver to get a
> board working but have no ongoing interest or can only really comment on
> the one specific configuration used on their particular hardware.  This
> means getting people to add MAINTAINERS entries is a bit more tricky
> than it needs to be, even if they could offer useful review on changes.
> ---------------------------------------------------

> So for Mark's case, the current behavior works reasonably well.

Actually I've got pretty much all the problems Ted has with it - when I
use get_maintainer it's done in conjunction with my knowledge of who the
people who turn up are and what the chances are that they'd have been
doing substantial work on the code.  Half the time it's just because I
need to look up someone's e-mail address.

> Tell me something Ted.  Have you in the last 5 years or
> so done any work in the kernel outside of fs or modified
> files outside of fs when fs structures weren't changed?

> Are you representative of the typical user of a script like
> get_maintainer or checkpatch?  Does it matter that much?

I've personally always thought of get_maintainer as being more useful
for more experienced developers since you have to have a reasonable idea
of what it's giving you to be able to parse the output effectively.

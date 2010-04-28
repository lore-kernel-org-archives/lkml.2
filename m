Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0D1Qd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:33:28 -0400
Received: from mail.perches.com ([173.55.12.10]:1776 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0D1Qd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:33:27 -0400
Subject: Re: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled
 files into 1 clean file
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       devel@driverdev.osuosl.org, Scott Smedley <ss@aao.gov.au>,
       Jason Baldus <jason.baldus@gmail.com>, linux-kernel@vger.kernel.org,
       Harley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
In-Reply-To: <10533.1272471159@localhost>
References: <20100329032301.GC27607@verge.net.au>
	 <cover.1269847733.git.joe@perches.com>
	 <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
	 <20100427230228.GB17260@kroah.com>
	 <1272432603.23132.30.camel@Joe-Laptop.home>
	 <20100428053427.GA14510@kroah.com>
	 <1272433474.23132.34.camel@Joe-Laptop.home>
	 <20100428055237.GA14978@suse.de>
	 <1272434430.23132.35.camel@Joe-Laptop.home>  <10533.1272471159@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 09:33:25 -0700
Message-ID: <1272472405.18228.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 12:12 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Apr 2010 23:00:30 PDT, Joe Perches said:
> > On Tue, 2010-04-27 at 22:52 -0700, Greg KH wrote:
> > > > I seem to be learning that you little taste.
> > > -ENOPARSE
> > 
> > Choosing competing patches based on date received
> > order not quality is poor taste.
> 
> So you're saying when Greg gets a somewhat ugly but passable patch 2 weeks ago,
> he's supposed to *just know* that you'll be submitting a possibly better one 2
> weeks later and wait for it to show up?

No, I'm saying that when Greg gets multiple
patches for the same module and doesn't act on
any of them for several weeks, (in this case
one 6 weeks ago, and two others 4 weeks ago)
he should select the better patches, not just
apply the first one in chronological order.

> How is that supposed to work in reality?

Apparently slowly and fitfully.

If the cycle time was shorter and the feedback
better, it would be less of an issue.

Greg has explained he was unavailable to look at
patches for an extended period.  Unfortunately
that extended period was immediately after a talk
Greg gave and an article Greg authored designed
to generate new contributor patches for staging.

The talk and articled worked.

Many new individuals followed his template format
producing cleanup patches, some good, some less
good.  Few if any of those patches received feedback
from Greg or had notice of patch status for that
extended period.

It would be better if the backlog of patches were
order sifted by quality than chronology.

cheers, Joe


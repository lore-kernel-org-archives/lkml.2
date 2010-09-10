Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab0IJKSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:18:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43336 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750915Ab0IJKSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:18:20 -0400
Date: Fri, 10 Sep 2010 11:18:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910101818.GF3068@rakim.wolfsonmicro.main>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
 <20100910095259.GC23903@sirena.org.uk>
 <1284113066.1783.69.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284113066.1783.69.camel@Joe-Laptop>
X-Cookie: Did I do an INCORRECT THING??
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:04:26AM -0700, Joe Perches wrote:

> It'd be great if the ARM/embedded folk would spend
> some effort improving the MAINTAINERS file pattern
> coverage.

Half the problem is that a lot of drivers aren't maintained by the
people who wrote them - for example, they wrote the driver to get a
board working but have no ongoing interest or can only really comment on
the one specific configuration used on their particular hardware.  This
means getting people to add MAINTAINERS entries is a bit more tricky
than it needs to be, even if they could offer useful review on changes.

> One possible improvement that get_maintainers could
> add is to [optionally] CC the author of the first
> commit when there's no listed maintainer.

That might be a nice option (though it will still give false positives).
Something based on percentage of the driver written rather than log
entry counts might also be interesting.

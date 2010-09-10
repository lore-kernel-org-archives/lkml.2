Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0IJLHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:07:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45906 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752898Ab0IJLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:07:44 -0400
Date: Fri, 10 Sep 2010 12:07:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910110742.GC7259@rakim.wolfsonmicro.main>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
 <20100910095259.GC23903@sirena.org.uk>
 <1284113066.1783.69.camel@Joe-Laptop>
 <20100910101818.GF3068@rakim.wolfsonmicro.main>
 <1284115665.1783.144.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284115665.1783.144.camel@Joe-Laptop>
X-Cookie: The more the merrier.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:47:45AM -0700, Joe Perches wrote:
> On Fri, 2010-09-10 at 11:18 +0100, Mark Brown wrote:

> > That might be a nice option (though it will still give false positives).

> Anything that uses git will give false positives.
> Anything that uses MAINTAINERS will give false positives.

Agreed, the main problem here is people thinking the tool is more magic
than it actually is rather than a problem in the tool itself.

> Maybe --rolestats should be extended to include line counts
> if --git-blame is used.

> --git-blame can be very slow, it shouldn't be a default option.

Yes, agreed.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0IHViZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:38:25 -0400
Received: from void.printf.net ([89.145.121.20]:56914 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab0IHViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:38:19 -0400
Date: Wed, 8 Sep 2010 22:37:41 +0100
From: Chris Ball <cjb@laptop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100908213740.GA7550@void.printf.net>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru> <20100907153813.936db0c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907153813.936db0c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Sep 07, 2010 at 03:38:13PM -0700, Andrew Morton wrote:
> > I noticed no throughput drop neither with PIO transfers nor
> > with DMA (tested on MPC8569E CPU), while latencies should be
> > greatly improved.
> 
> This patchset isn't causing any problems yet, but may do so in the
> future and will impact the validity of any testing.  It seems to be
> kind of stuck.  Should I drop it all?

I suggest keeping it -- I'll find time to test it out here soon, and
will keep it in mind as a possible regression cause.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

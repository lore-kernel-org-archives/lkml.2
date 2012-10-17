Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2JQSNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:13:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49709 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756577Ab2JQSNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:13:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+5Bh47H49NuTr+55Wf+Am
Date: Wed, 17 Oct 2012 11:13:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?UMOpdGVy?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Deepak Saxena <dsaxena@plexity.net>,
        Chris Ball <cjb@laptop.org>, Matt Mackall <mpm@selenic.com>,
        Venkatraman S <svenkatr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove
 include plat/cpu.h
Message-ID: <20121017181330.GV15569@atomide.com>
References: <20121008173452.10603.53886.stgit@muffinssi>
 <20121008173557.10603.18539.stgit@muffinssi>
 <5073E84E.4090408@ti.com>
 <20121010001943.GK12552@atomide.com>
 <20121016000722.GH15569@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121016000722.GH15569@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121015 17:09]:
> * Tony Lindgren <tony@atomide.com> [121009 17:21]:
> > * Péter Ujfalusi <peter.ujfalusi@ti.com> [121009 02:03]:
> > > On 10/08/2012 07:35 PM, Tony Lindgren wrote:
> > > 
> > > > - omap-dma.c and omap-pcm.c can test the arch locally as
> > > >   omap1 and omap2 cannot be compiled together because of
> > > >   conflicting compiler flags
> > > 
> > > >  sound/soc/omap/omap-pcm.c         |    9 +++++++--
> > > 
> > > Tony: is this going to be included in 3.7?
> > 
> > Hmm I guess we could try to get this out of the way
> > to cut down the dependencies. Let's if maintainers
> > of the other affected drivers this is OK for the
> > -rc series.
> 
> It seems that nobody needs these until for v3.8, so I'll
> be applying this into omap-for-v3.8/cleanup-headers-prepare
> branch soon.
> 
> Anybody else care to ack?

OK pushed out now with just that patch in the branch in case
driver branches need to merge it in too to avoid conflicts.

Regards,

Tony

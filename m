Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2LSKCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:02:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50762 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2LSKCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:02:48 -0500
Message-ID: <1355911317.5273.10.camel@cumari.coelho.fi>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
From: Luciano Coelho <coelho@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Date: Wed, 19 Dec 2012 12:01:57 +0200
In-Reply-To: <20121219094552.GN4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
	 <20121218095450.GB27751@arwen.pp.htv.fi>
	 <20121219094552.GN4985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, 2012-12-19 at 09:45 +0000, Mark Brown wrote:
> On Tue, Dec 18, 2012 at 11:54:50AM +0200, Felipe Balbi wrote:
> 
> > damn, this is still part of our v3.7-rc kernel. Original commit was done
> > with no testing whatsoever and caused a big regression to (at least)
> > TI's WiFi driver which depend on SDIO to function.
> 
> > Too bad things break and even when reported nobody gives a rat's ***
> > about them :-s
> 
> I guess it's going to be even more of an issue going forward given the
> recent events but FWIW it was always very unusual to see any review of
> any TWL patches, the PMIC appeared to have been rather abandoned so the
> only way of getting any testing was to put stuff in -next and hope.

Unfortunately I don't know how many of us are using this specific
platform with the latest kernel, so not much testing is done.


> Mind you, if there is an issue it doesn't seem that serious given that
> it took at least one kernel release before anyone noticed and even when
> they did you're the first person who bothered to respond...

To me it has been very serious.  I had to revert a bunch of patches to
be able to continue working with the mainline.  It took me a while to
see the bug because I've been away during the 3.6 cycle.

I think one of the reasons not many people use the mainline with TWL is
exactly because something seems to break on every new kernel release.
I'm one of those who care and report things when I see them.

I think saying that it is not important because only one person reported
it is not a good excuse.  I would at least have liked seeing an answer
saying, "this can't be fixed because of this and that" or "can you try
to fix it by doing this or that".

--
Cheers,
Luca.


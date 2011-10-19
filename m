Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1JSRcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:32:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46777 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab1JSRcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:32:17 -0400
Date: Wed, 19 Oct 2011 19:32:10 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Girdwood, Liam" <lrg@ti.com>, Manuel Lauss <manuel.lauss@googlemail.com>,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Axel Lin <axel.lin@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/au1x: keep pointer to resource so it can
 be freed
In-Reply-To: <20111019164836.GC4275@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1110191930450.31584@ask.diku.dk>
References: <1318909555-12933-3-git-send-email-julia@diku.dk>
 <CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
 <CABS+qY2pBkNjHUKrtD3QttQOQD-LpStHopSGxzeG-iyc7RtVgw@mail.gmail.com>
 <20111019164836.GC4275@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure how to proceed, since I originally sent 3 patches, all with 
the same problem.  I send another single patch that fixed the problems 
with nicer names than r and r1.  Should I send another single patch with 
Manuel's solution?  Or does Manuel want to do that?

julia


On Wed, 19 Oct 2011, Mark Brown wrote:

> On Wed, Oct 19, 2011 at 05:47:25PM +0100, Girdwood, Liam wrote:
> > > From 940e38b3f0beff6fcd8f62f627dce622e9ca0e54 Mon Sep 17 00:00:00 2001
> > > From: Manuel Lauss <manuel.lauss@googlemail.com>
> > > Date: Wed, 19 Oct 2011 16:45:12 +0200
> > > Subject: [PATCH] ASoC: au1x: fix error paths in ac97c/i2cs probe callbacks.
> > >
> > > add iounmap() and release the correct mem resource.
> > >
> > > Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
> 
> > Acked-by: Liam Girdwood <lrg@ti.com>
> 
> ...but since it was buried in the middle of the e-mail please resend
> with Liam's ack for application.
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

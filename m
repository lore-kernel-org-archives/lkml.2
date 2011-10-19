Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1JSReS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:34:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab1JSReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:34:16 -0400
Date: Wed, 19 Oct 2011 18:34:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Girdwood, Liam" <lrg@ti.com>, Manuel Lauss <manuel.lauss@googlemail.com>,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Axel Lin <axel.lin@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/au1x: keep pointer to resource so it can
 be freed
Message-ID: <20111019173413.GF4275@opensource.wolfsonmicro.com>
References: <1318909555-12933-3-git-send-email-julia@diku.dk>
 <CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
 <CABS+qY2pBkNjHUKrtD3QttQOQD-LpStHopSGxzeG-iyc7RtVgw@mail.gmail.com>
 <20111019164836.GC4275@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1110191930450.31584@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110191930450.31584@ask.diku.dk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 07:32:10PM +0200, Julia Lawall wrote:
> I'm not sure how to proceed, since I originally sent 3 patches, all with 
> the same problem.  I send another single patch that fixed the problems 
> with nicer names than r and r1.  Should I send another single patch with 
> Manuel's solution?  Or does Manuel want to do that?

I dunno, I guess sending Manuel's patch along with your other changes
might be the way forward?

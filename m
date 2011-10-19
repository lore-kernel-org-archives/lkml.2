Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1JSQsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:48:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38959 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790Ab1JSQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:48:39 -0400
Date: Wed, 19 Oct 2011 17:48:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Girdwood, Liam" <lrg@ti.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, Julia Lawall <julia@diku.dk>,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Axel Lin <axel.lin@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/au1x: keep pointer to resource so it can
 be freed
Message-ID: <20111019164836.GC4275@opensource.wolfsonmicro.com>
References: <1318909555-12933-3-git-send-email-julia@diku.dk>
 <CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
 <CABS+qY2pBkNjHUKrtD3QttQOQD-LpStHopSGxzeG-iyc7RtVgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABS+qY2pBkNjHUKrtD3QttQOQD-LpStHopSGxzeG-iyc7RtVgw@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 05:47:25PM +0100, Girdwood, Liam wrote:
> > From 940e38b3f0beff6fcd8f62f627dce622e9ca0e54 Mon Sep 17 00:00:00 2001
> > From: Manuel Lauss <manuel.lauss@googlemail.com>
> > Date: Wed, 19 Oct 2011 16:45:12 +0200
> > Subject: [PATCH] ASoC: au1x: fix error paths in ac97c/i2cs probe callbacks.
> >
> > add iounmap() and release the correct mem resource.
> >
> > Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>

> Acked-by: Liam Girdwood <lrg@ti.com>

...but since it was buried in the middle of the e-mail please resend
with Liam's ack for application.

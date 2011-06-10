Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab1FJSPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:15:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47845 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757733Ab1FJSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:15:41 -0400
Date: Fri, 10 Jun 2011 19:15:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [Device-drivers-devel] [alsa-devel] [PATCH 2/3] ASoC: Blackfin:
 Add bf5xx-adau1701 machine driver
Message-ID: <20110610181538.GS26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de>
 <20110610173004.GJ26441@sirena.org.uk>
 <BANLkTimBJbkYJnU5vgmo+a5eerRroE1uBg@mail.gmail.com>
 <20110610180137.GP26436@opensource.wolfsonmicro.com>
 <BANLkTi=S2GayUj8-ctjbDOE_bcEb-6GtJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=S2GayUj8-ctjbDOE_bcEb-6GtJQ@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 02:13:05PM -0400, Mike Frysinger wrote:

> often times, people do have just basic needs, but i see what you mean.
>  i want the base driver to be flexible enough to handle all the base
> changes (diff SPORT num and perhaps addresses), but anything beyond
> that i'd expect someone to write a custom driver.  perhaps renaming
> the Kconfig description to be like "Basic Blackfin connection to XXX
> Codec" would be sufficient ?  and then add a few more details to the
> help text ?

Yes, that's exactly the sort of thing I'd like to see.  It shouldn't be
that big a change to the code, it's more about making it clear that it's
a 90% case driver rather than the only way to connect things up.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1AaMFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:05:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46357 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1AaMFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:05:09 -0500
Subject: Re: [alsa-devel] [PATCH] soc: neo1973_wm8753 audio support does
	not require scoop
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        alsa-devel@alsa-project.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110131112339.GD11937@sirena.org.uk>
References: <201101281200.18371.hartleys@visionengravers.com>
	 <20110131112339.GD11937@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:05:04 +0000
Message-ID: <1296475504.3316.46.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 11:23 +0000, Mark Brown wrote:
> On Fri, Jan 28, 2011 at 12:00:18PM -0700, H Hartley Sweeten wrote:
> > This driver does not use any of the functionality provided by the scoop
> > hardware.  Remove the unneeded header.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> CCing in Liam.  As I think I've mentioned before please do remember to
> CC maintainers.
> 
> > 
> > ---
> > 
> > diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
> > index c7a2451..c5b3113 100644
> > --- a/sound/soc/samsung/neo1973_wm8753.c
> > +++ b/sound/soc/samsung/neo1973_wm8753.c
> > @@ -24,7 +24,6 @@
> >  #include <sound/tlv.h>
> >  
> >  #include <asm/mach-types.h>
> > -#include <asm/hardware/scoop.h>
> >  #include <mach/regs-clock.h>
> >  #include <mach/regs-gpio.h>
> >  #include <mach/hardware.h>


Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


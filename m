Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2CZPkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:40:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53860 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab2CZPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:40:18 -0400
Date: Mon, 26 Mar 2012 16:40:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120326154009.GA17506@sirena.org.uk>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
 <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
 <20120321160913.GF3226@opensource.wolfsonmicro.com>
 <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
X-Cookie: May cause drowsiness.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 09:12:39AM +0900, Tomoya MORINAGA wrote:
> On Thu, Mar 22, 2012 at 1:09 AM, Mark Brown

> > So, I just said to the SPEAr guys that I really want to see support for
> > non-cyclic dmaengine added to the helper library rather than open
> > coding. ?We're seeing lots of platforms moving to dmaengine (as well as

> Do you mean you don't accept our platform/machine driver's patches
> unless your DMA library will have supported non-cyclic dmaengine ?
> Or if I'll modify your minor comments, can you accept our patches ?

I really want to see the dmaengine interaction factored out into a
library.  Like I say we've got lots of platforms doing this all being
submitted at the same time, plus most of the work already there in the
form of the base library.  It shouldn't be too much work for the various
platforms to collaborate on factoring this code out.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1CPMvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:51:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44395 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1CPMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:50:55 -0400
Date: Wed, 16 Mar 2011 12:50:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
Message-ID: <20110316125052.GB8369@sirena.org.uk>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com> <20110311153134.GO1760@opensource.wolfsonmicro.com> <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com> <20110314181531.GA32434@opensource.wolfsonmicro.com> <AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com> <1300275412.3432.46.camel@odin> <AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 01:43:25PM +0100, Linus Walleij wrote:
> 2011/3/16 Liam Girdwood <lrg@slimlogic.co.uk>:

> > Btw, you have a few other regulator patches recently in amongst MFD and
> > ARM updates. I assume these will go via MFD ?

> The TPS6105x stuff will go through MFD, hopefully.

Note that this isn't 100% required for new drivers - since you have a
dependency on the MFD you can merge subdevices through their own trees
and they won't cause problems as they can't be built until the MFD is
merged and makes the core symbol available.

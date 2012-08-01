Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2HATln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:41:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51199 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2HATlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:41:42 -0400
Date: Wed, 1 Aug 2012 20:41:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/6] ASoC: dapm: If one widget fails, do
 not force all subsequent widgets to fail too
Message-ID: <20120801194134.GA4103@sirena.org.uk>
References: <5017EAC3.3080504@linaro.org>
 <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
 <20120801160824.GB11892@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801160824.GB11892@opensource.wolfsonmicro.com>
X-Cookie: Touch tone phones only.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 05:08:24PM +0100, Mark Brown wrote:
> On Wed, Aug 01, 2012 at 02:50:32PM +0100, Lee Jones wrote:

> > >It's very disappointing to see such an error exist, and even more
> > >disappointing that there's no interest in fixing the driver.

> > This is incorrect. I'm sure the driver will be fixed post-haste when
> > Ola returns back from vacation. If I can find some time I might
> > dabble in the mean-time also.

> It may not be what you're intending but it's unfortuantely what's I'm
> seeing.

Just to expand on this a bit since I've found myself pushing back in
this sort of way far too often with these recent serieses and it's
making everyone grumpy:

What I'm seeing here is a lot of patches getting sent with problems that
I'd really not expect from someone sending such a high volume of
patches.  Things like the lack of documentation for the DT bindings for
example, it's something that's mandatory and which people doing lots of
device tree work really ought to be aware of.  There's also noticable
pushback with fixing some of these issues, and like I say this happens
often enough to be really noticeable.

This isn't awesome from a review point of view, it's not nice to find
issues in things and when it happens a lot for the wrong sort of thing
it ends up seeming like the time spent doing the reviews isn't valued.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1IDP11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:27:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58308 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754457Ab1IDP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:27:24 -0400
Date: Sun, 4 Sep 2011 08:27:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: codecs: Remove unused mutex
Message-ID: <20110904152718.GA21528@opensource.wolfsonmicro.com>
References: <1315140751.8673.1.camel@phoenix>
 <20110904141015.GB3668@opensource.wolfsonmicro.com>
 <CAF+7xWn=1M+iGuXVt6cA0j+b4wZNJh+iyE7ChTQf2xaKCqbaMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWn=1M+iGuXVt6cA0j+b4wZNJh+iyE7ChTQf2xaKCqbaMw@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 10:48:09PM +0800, Axel Lin wrote:
> 2011/9/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > This has already been done for wm9090, can you resubmit with just the
> > alc5623 change please?

> Ok. A new patch "ASoC: alc5623: Remove unused mutex" is on the way.

Thanks.  The patch has been sitting there for a little while but it's
not on kernel.org due to the lockdown after the compromise - until we
can start pushing updates again there's a risk of overlaps like this.

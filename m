Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1JKNbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:31:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60724 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab1JKNbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:31:23 -0400
Date: Tue, 11 Oct 2011 14:31:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Writing register default value for the reset
 register
Message-ID: <20111011133118.GB3471@opensource.wolfsonmicro.com>
References: <1318326900.3526.2.camel@phoenix>
 <20111011123305.GA2899@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011123305.GA2899@opensource.wolfsonmicro.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 01:33:05PM +0100, Dimitris Papastamos wrote:
> On Tue, Oct 11, 2011 at 05:55:00PM +0800, Axel Lin wrote:
> > The WM8983 can be reset by performing a write of any value to
> > the software reset register.

> > -	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0x8983);
> > +	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0);

> We should probably just handle the reset register specially during
> resume.

I really don't think it's worth the code complexity to add special
handling like that, this is a trivial patch which avoids the need for
any extra infrastructure.

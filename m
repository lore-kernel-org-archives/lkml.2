Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2BBAPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:15:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60100 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2BBAPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:15:10 -0500
Date: Wed, 1 Feb 2012 17:15:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] gpio: tps65910: Add sleep control support
Message-ID: <20120202001508.GD15343@ponder.secretlab.ca>
References: <1328078344-11670-1-git-send-email-ldewangan@nvidia.com>
 <CACRpkdbNxTe928p=7XdZVbqqfC5k0s1fqE=8DNa5zmg40pjwrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbNxTe928p=7XdZVbqqfC5k0s1fqE=8DNa5zmg40pjwrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:30:54PM +0100, Linus Walleij wrote:
> On Wed, Feb 1, 2012 at 7:39 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> 
> > The device tps65910/tps65911 supports the sleep
> > functionality in some of gpios. If gpio is configured
> > in output mode and sleep is enabled then during device
> > sleep state, the output of gpio becomes LOW regardless
> > of non-sleep output value.
> > Such gpio can be used to control regulator switch such
> > that output of regulator is off in device sleep state.
> >
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > Changes from V1:
> > Taken care of review comments from Linus Walleij's
> > - Remove magic numbers and added macro for defining them.
> > - Used bool type for the platform's gpio sleep control data.
> 
> Thanks, looks good!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

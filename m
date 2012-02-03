Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab2BCTF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:05:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56182 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab2BCTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:05:29 -0500
Date: Fri, 3 Feb 2012 19:05:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl-core: Don't specify regulator consumers by
	struct device
Message-ID: <20120203190524.GA23505@opensource.wolfsonmicro.com>
References: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120203180850.GB17584@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203180850.GB17584@sortiz-mobl>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 07:08:50PM +0100, Samuel Ortiz wrote:
> On Fri, Feb 03, 2012 at 11:05:37AM +0000, Mark Brown wrote:

> > I'll apply this to the regulator tree as it's thrown up issues due to
> > the removal of dev from regulator_consumer_supply - please let me know
> > if this is an issue, I can back it out easily enough.

> When did the regulator API get modified ? During the last merge window, or is
> this one something Linus should be pulling ASAP ?

The API has been deprecated forever but it's only removed in -next.

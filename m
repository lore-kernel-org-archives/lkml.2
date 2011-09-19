Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1ISQUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:20:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44188 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756381Ab1ISQUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:20:11 -0400
Date: Mon, 19 Sep 2011 17:20:09 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v5] regmap: Incorporate the regcache core into
	regmap
Message-ID: <20110919162009.GA12324@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com> <4E77667D.8030404@metafoo.de> <20110919161358.GA540@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919161358.GA540@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 05:13:59PM +0100, Mark Brown wrote:
> On Mon, Sep 19, 2011 at 05:57:49PM +0200, Lars-Peter Clausen wrote:
> > Btw. what should happen if both cache_bypass and cache_only are set? Or is that
> > an invalid configuration?
> 
> That's not sensible.  Probably BUG_ON().

Yes this used to be a BUG_ON() on some of the previous versions of the
patches.

Thanks,
Dimitris

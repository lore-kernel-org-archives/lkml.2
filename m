Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1JJKuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:50:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51573 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab1JJKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:50:22 -0400
Date: Mon, 10 Oct 2011 11:50:19 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: Allow caches for devices with no defaults
Message-ID: <20111010105019.GA21469@opensource.wolfsonmicro.com>
References: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20111010084126.GA2563@opensource.wolfsonmicro.com> <20111010092345.GA3040@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010092345.GA3040@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:23:46AM +0100, Mark Brown wrote:
> On Mon, Oct 10, 2011 at 09:41:26AM +0100, Dimitris Papastamos wrote:
> > On Sun, Oct 09, 2011 at 02:44:36PM +0100, Mark Brown wrote:
> 
> > > +	} else if (map->num_reg_defaults_raw) {
> > >  		/* Some devices such as PMICs don't have cache defaults,
> > >  		 * we cope with this by reading back the HW registers and
> > >  		 * crafting the cache defaults by hand.
> 
> > We could probably then also remove the first check in
> > regcache_hw_init() I guess.
> 
> > The one:
> 
> > if (!map->num_reg_defaults_raw)
> > 	return -EINVAL;
> 
> I felt it was clearer to have the defaults init fail if it doesn't work
> so that the callers know what happened.  Otherwise the callers have to
> figure out if it succeeded because it did what it was supposed to.

Aw right yes.

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

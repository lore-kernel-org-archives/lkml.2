Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab1E0Hp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:45:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33496 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1E0Hp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:45:56 -0400
Date: Fri, 27 May 2011 01:45:52 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [alsa-devel] [PATCH/RFC] gpio: add GPIOF_ values regardless on
 kconfig settings
Message-ID: <20110527074552.GA907@ponder.secretlab.ca>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
 <20110523134815.fb87933a.randy.dunlap@oracle.com>
 <20110523224659.GB19533@opensource.wolfsonmicro.com>
 <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com>
 <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com>
 <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524075248.GB19734@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 08:52:48AM +0100, Mark Brown wrote:
> On Mon, May 23, 2011 at 09:58:39PM -0700, Randy Dunlap wrote:
> 
> > Below is a patch that makes the 2 reported drivers build when
> > CONFIG_GPIOLIB is disabled and CONFIG_GENERIC_GPIO is disabled.
> > What do you think of the patch?
> 
> Looks OK for me on a first scan, though probably the best approach is to
> go through and just enable gpiolib on all the architectures that don't
> have it already yet - that's the more generally useful approach as it
> means that if plugin boards for the platform need to use gpiolib they
> can.  I already did this for Alpha, I guess I'll try to look see what
> other architectures could use it.

Looks okay.  Please repost with proper s-o-b so I can pick it up.

g.


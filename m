Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1EXHxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:53:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38175 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1EXHxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:53:07 -0400
Date: Tue, 24 May 2011 08:52:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [alsa-devel] [PATCH/RFC] gpio: add GPIOF_ values regardless on
	kconfig settings
Message-ID: <20110524075248.GB19734@sirena.org.uk>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523134815.fb87933a.randy.dunlap@oracle.com> <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com> <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com> <20110524014959.GA27710@opensource.wolfsonmicro.com> <4DDB3AFF.9030006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB3AFF.9030006@oracle.com>
X-Cookie: Save gas, don't eat beans.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 09:58:39PM -0700, Randy Dunlap wrote:

> Below is a patch that makes the 2 reported drivers build when
> CONFIG_GPIOLIB is disabled and CONFIG_GENERIC_GPIO is disabled.
> What do you think of the patch?

Looks OK for me on a first scan, though probably the best approach is to
go through and just enable gpiolib on all the architectures that don't
have it already yet - that's the more generally useful approach as it
means that if plugin boards for the platform need to use gpiolib they
can.  I already did this for Alpha, I guess I'll try to look see what
other architectures could use it.

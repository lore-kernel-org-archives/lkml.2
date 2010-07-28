Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0G1Grc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:47:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55741 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0G1Gr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:47:29 -0400
Date: Wed, 28 Jul 2010 08:47:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] kconfig: introduce alldefconfig + savedefconfig
Message-ID: <20100728064723.GA14914@pengutronix.de>
References: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100725213808.GA5814@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Sun, Jul 25, 2010 at 11:38:08PM +0200, Sam Ravnborg wrote:
> After reading some of the mails about the
> defconfig files I decided to take a look at kconfig.
> 
> We already decided to go for a solution where the defconfig
> files contains only the minimal configuration.
> Uwe developed a script to assist but having native support
> in kconfig is preferable.
> 
> This patch set introduce "alldefconfig".
> alldefconfig create a configuration with all values set
> to default values.
> This can be usefull when we check if we do have a sane
> set of default values. Rhe config can be inspected
> using menuconfig.
> 
> The patches also introduce "savedefconfig" which
> reads the current configuration and save it
> as a minimal configuration.
> 
> In my testing I benchmarked it with one
> of the arm defconfings and the final result is
> the same (symbols appear in different order).
I would prefer to have them in the same order.  I havn't checked the
details, but I really like getting support for minimal defconfigs done
in kconfig directly.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

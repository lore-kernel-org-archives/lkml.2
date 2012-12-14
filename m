Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2LNB4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:56:11 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53336 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2LNB4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:56:09 -0500
Date: Fri, 14 Dec 2012 03:56:05 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@debian.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Tony Lindgren <tony@atomide.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new
 watchdog core
Message-ID: <20121214015605.GC6823@blackmetal.musicnaut.iki.fi>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
 <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
 <20121112224703.GT6801@atomide.com>
 <20121214012336.GA402@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214012336.GA402@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 14, 2012 at 02:23:36AM +0100, Sebastian Reichel wrote:
> On Mon, Nov 12, 2012 at 02:47:03PM -0800, Tony Lindgren wrote:
> > * Aaro Koskinen <aaro.koskinen@iki.fi> [121112 10:49]:
> > > Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
> > > multiple watchdogs. Since the new watchdog core supports multiple
> > > watchdogs, all watchdog drivers used on OMAP should be converted.
> > > 
> > > The legacy watchdog device node is still created, so this should not
> > > break existing users.
> > > 
> > > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
> > > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > > Cc: Wim Van Sebroeck <wim@iguana.be>
> > 
> > Wim, looks like these will cause merge conflicts with what we
> > have already queued in omap-for-v3.8/cleanup-prcm as patch
> > "watchdog: OMAP: use standard GETBOOTSTATUS interface; use
> > platform_data fn ptr" along with other ARM multiplatform
> > related clean up. If these look ackable to you, I can queue
> > these that's OK to you.
> 
> What's the status of this patchset? If I'm not mistaken it is
> neither included in linux-omap, nor in linux-watchdog-next.

Since it's not in -next, then I guess it won't appear in 3.8. Once
the 3.8-rc1 is out, I will continue rebasing/retesting/resending the
patch set...

A.

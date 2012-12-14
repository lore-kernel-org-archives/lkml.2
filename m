Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2LNBdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:33:10 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64704 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755747Ab2LNBdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:33:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uxlgpsQaTwzZJb2zpX5sM
Date: Thu, 13 Dec 2012 17:32:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new
 watchdog core
Message-ID: <20121214013256.GM4989@atomide.com>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
 <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
 <20121112224703.GT6801@atomide.com>
 <20121214012336.GA402@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214012336.GA402@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [121213 17:26]:
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

It should be all linux-watchdog-next with what got merged into
the mainline kernel today. No more arch/arm/*omap*/ dependencies
AFAIK.

Regards,

Tony

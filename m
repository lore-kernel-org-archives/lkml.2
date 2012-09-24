Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2IXQT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:19:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52797 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756658Ab2IXQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:19:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YWKTSq9ERu3isdigmqQNZ
Date: Mon, 24 Sep 2012 09:19:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 omap_dss2 tree
Message-ID: <20120924161944.GC28835@atomide.com>
References: <20120924195305.588277e94ce701abc5e5a6c5@canb.auug.org.au>
 <201209241243.39462.arnd@arndb.de>
 <1348492306.2361.48.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348492306.2361.48.camel@deskari>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [120924 06:12]:
> Hi Arnd,
> 
> On Mon, 2012-09-24 at 12:43 +0000, Arnd Bergmann wrote:
> > On Monday 24 September 2012, Stephen Rothwell wrote:
> > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > drivers/video/omap/lcd_ams_delta.c between commit 9586778de558 ("OMAPFB1:
> > > remove unnecessary includes") from the  tree and commit e27e35ec735f
> > > ("ARM: OMAP1: Move board-ams-delta.h from plat to mach") from the arm-soc
> > > tree.
> > > 
> > > The latter removed a superset of the former (as far as include files is
> > > concerned), so I used that and can carry the fix as necessary (no action
> > > is required).
> > > 
> > 
> > Hi Stephen,
> > 
> > I looked at all your reports and your fixes are looking good to me.
> > 
> > I'm already building all ARM defconfigs now and have fixup patches for the
> > instances that went wrong or introduced new warnings, I'll do that again
> > on top of today's linux-next tree.
> > 
> > The merge window is going to be fun with all those conflicts, but I don't
> > have a better idea either.
> 
> If there's a stable branch for the OMAP platform changes, I could merge
> it to omapdss tree and fix the conflicts. But if I've understood right,
> Linus doesn't really like merges just for the sake of fixing conflicts.
> 
> So far all the omapdss conflicts seem trivial, though.

Trivial ones should be OK, but maybe you find something
minimal with the following to find tags that you can pull
into your branch make things easier:

$ git log --pretty=oneline --merges v3.6-rc7..arm-soc/for-next arch/arm/*omap*/* | grep "Merge tag" | grep omap

Regards,

Tony

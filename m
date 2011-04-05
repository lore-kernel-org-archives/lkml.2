Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1DETRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:17:44 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:44682 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab1DETRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:17:42 -0400
Date: Tue, 5 Apr 2011 21:17:16 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Joe Perches <joe@perches.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Resend: Change mail adress of Hans J. Koch
Message-ID: <20110405191715.GF7028@local>
References: <20110405185621.GE7028@local>
 <1302030520.3969.3.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302030520.3969.3.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 12:08:40PM -0700, Joe Perches wrote:
> On Tue, 2011-04-05 at 20:56 +0200, Hans J. Koch wrote:
> > My old mail address doesn't exist anymore. This patch changes all occurences
> > in MAINTAINERS to my new address. I already sent this in Oct. 2010, but it
> > somehow never made it to mainline (is there a MAINTAINERS maintainer?)
> 
> The closest thing may be Andrew Morton.
> I send my MAINTAINERS patches through him.
> These patches are typically 1 release delayed.
> 
> $ ./scripts/get_maintainer.pl -f MAINTAINERS
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:79/549=14%)
> Joe Perches <joe@perches.com> (commit_signer:50/549=9%)
> linux-kernel@vger.kernel.org (open list)

Hmpf, could have thought of that myself... Thanks!

Hans

> 
> 
> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> > ---
> >  MAINTAINERS |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6b4b9cd..b96f3b3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1063,7 +1063,7 @@ F:	arch/arm/mach-shmobile/
> >  F:	drivers/sh/
> >  
> >  ARM/TELECHIPS ARM ARCHITECTURE
> > -M:	"Hans J. Koch" <hjk@linutronix.de>
> > +M:	"Hans J. Koch" <hjk@hansjkoch.de>
> >  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> >  S:	Maintained
> >  F:	arch/arm/plat-tcc/
> > @@ -4077,7 +4077,7 @@ F:	drivers/video/matrox/matroxfb_*
> >  F:	include/linux/matroxfb.h
> >  
> >  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
> > -M:	"Hans J. Koch" <hjk@linutronix.de>
> > +M:	"Hans J. Koch" <hjk@hansjkoch.de>
> >  L:	lm-sensors@lm-sensors.org
> >  S:	Maintained
> >  F:	Documentation/hwmon/max6650
> > @@ -6618,7 +6618,7 @@ F:	fs/hostfs/
> >  F:	fs/hppfs/
> >  
> >  USERSPACE I/O (UIO)
> > -M:	"Hans J. Koch" <hjk@linutronix.de>
> > +M:	"Hans J. Koch" <hjk@hansjkoch.de>
> >  M:	Greg Kroah-Hartman <gregkh@suse.de>
> >  S:	Maintained
> >  F:	Documentation/DocBook/uio-howto.tmpl
> 
> 
> 
> 

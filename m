Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab0EEPUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:20:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:54018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0EEPUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:20:14 -0400
Date: Wed, 5 May 2010 08:20:00 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
       Jakob Viketoft <jakob.viketoft@bitsim.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100505152000.GC16294@suse.de>
References: <4BC8330E.6000503@bitsim.com>
 <20100416100126.GI30801@buzzloop.caiaq.de>
 <4BC84766.5060208@bitsim.com>
 <4BC8493D.60900@bitsim.com>
 <20100416112820.GM30801@buzzloop.caiaq.de>
 <20100416112931.GN30801@buzzloop.caiaq.de>
 <n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com>
 <20100505080015.GD30801@buzzloop.caiaq.de>
 <u2nf17812d71005050228x3c19060n9a096d7bcc1db4d6@mail.gmail.com>
 <20100505094405.GG30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100505094405.GG30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:44:05AM +0200, Daniel Mack wrote:
> On Wed, May 05, 2010 at 05:28:45PM +0800, Eric Miao wrote:
> > On Wed, May 5, 2010 at 4:00 PM, Daniel Mack <daniel@caiaq.de> wrote:
> > > On Wed, May 05, 2010 at 03:45:34PM +0800, Eric Miao wrote:
> > >> On Fri, Apr 16, 2010 at 7:29 PM, Daniel Mack <daniel@caiaq.de> wrote:
> > >> > On Fri, Apr 16, 2010 at 01:28:20PM +0200, Daniel Mack wrote:
> > >> >> On Fri, Apr 16, 2010 at 01:25:49PM +0200, Jakob Viketoft wrote:
> > >> >> > Adding a "#include <mach/mfp.h>" seem to cure this problem. If you
> > >> >> > agree I can supply a new patch with the correct solution this time.
> > >> >>
> > >> >> Ok. Add it to colibri.h, and while at it, you can kick the ax88796.h
> > >> >> inclusion. That's a leftover and isn't needed.
> > >> >
> > >> > And Cc: stable@kernel.org for the backmerge to 2.6.33.
> > >> >
> > >>
> > >> Jakob, any update on this?
> > >
> > > Jakob provided an updated patch for this:
> > >
> > >  http://lkml.org/lkml/2010/4/16/100
> > >
> > 
> > Looks it didn't make into -stable.
> 
> Greg, stable@kernel.org was in Cc: for the patch in the URL above.
> Any chance to get this in?

Is it in Linus's tree?  If so, what is the git commit id of it?  If you
properly tag the patch with "cc: stable <stable@kernel.org>" like you
did in the patch, then it will be automatically sent to me when it hits
Linus's tree.

I don't see this one in my queue at the moment.

thanks,

greg k-h

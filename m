Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0KQEAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:00:42 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51639 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0KQEAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:00:41 -0500
Date: Wed, 17 Nov 2010 13:00:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: linux-fbdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        James Simmons <jsimmons@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] fbdev git tree.
Message-ID: <20101117040005.GB2790@linux-sh.org>
References: <20101109093204.GB21086@linux-sh.org> <1289318208.2260.9.camel@cowboy> <20101109162249.GB22740@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109162249.GB22740@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:22:49AM +0900, Paul Mundt wrote:
> On Tue, Nov 09, 2010 at 12:56:48PM -0300, Davidlohr Bueso wrote:
> > On Tue, 2010-11-09 at 18:32 +0900, Paul Mundt wrote:
> > > The tree can be found at:
> > > 
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
> > > 
> > 
> > Could this be added to the MAINTAINERS file?
> > 
> >  FRAMEBUFFER LAYER
> >  L:     linux-fbdev@vger.kernel.org
> >  W:     http://linux-fbdev.sourceforge.net/
> > +T:
> > git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
> >  S:     Orphan
> >  F:     Documentation/fb/
> >  F:     drivers/video/fb*
> > 
> Yes, I'll queue an update for that later. I was going to wait until the
> patchwork stuff came up and then update it all in one shot.

Ok, the patchwork queue is up now also:

	https://patchwork.kernel.org/project/linux-fbdev/list/

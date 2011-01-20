Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1ATTIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:08:43 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:58663 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1ATTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:08:42 -0500
Date: Thu, 20 Jan 2011 20:08:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 36/37] tile: Use generic irq Kconfig
Message-ID: <20110120190818.GA22638@merkur.ravnborg.org>
References: <20110119205258.462759212@linutronix.de> <20110119210840.631350392@linutronix.de> <4D3884E3.8050009@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3884E3.8050009@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 01:54:27PM -0500, Chris Metcalf wrote:
> On 1/19/2011 4:50 PM, Thomas Gleixner wrote:
> > No functional change.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > ---
> >  arch/tile/Kconfig |   16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > Index: linux-2.6/arch/tile/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/arch/tile/Kconfig
> > +++ linux-2.6/arch/tile/Kconfig
> > @@ -1,22 +1,18 @@
> >  # For a description of the syntax of this configuration file,
> >  # see Documentation/kbuild/config-language.txt.
> >  
> > +config TILE
> > +       def_bool y
> > +       select HAVE_GENERIC_HARDIRQS
> > +       select GENERIC_IRQ_PROBE
> > +       select GENERIC_PENDING_IRQ if SMP
> > +
> >  [...]
> 
> I'm not sure it's legal to have two "config TILE" blocks in this Kconfig
> file; there's already one further down.

It is OK to have two "config TILE" blocks.
You should take care of moving the other one up after this goes in.

	Sam

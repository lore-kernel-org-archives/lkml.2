Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1HOETk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:19:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1HOETk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:19:40 -0400
Date: Sun, 14 Aug 2011 21:10:00 -0700
From: Greg KH <gregkh@suse.de>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        Ondrej Zary <linux@rainbow-software.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ft1000: fix build failure
Message-ID: <20110815041000.GA7488@suse.de>
References: <1313355177-12605-3-git-send-email-slyfox@gentoo.org>
 <20110814222351.GA12930@suse.de>
 <20110815061833.39bc5034@sf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815061833.39bc5034@sf.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 06:18:33AM +0300, Sergei Trofimovich wrote:
> On Sun, 14 Aug 2011 15:23:51 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Sun, Aug 14, 2011 at 11:52:53PM +0300, Sergei Trofimovich wrote:
> > > Found on allmodconfig build (ARCH=alpha)
> > > 
> > >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg':
> > >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80: error: implicit declaration of function 'inw'
> > >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_reg':
> > >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86: error: implicit declaration of function 'outw'
> > > 
> > > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > > Cc: Marek Belisko <marek.belisko@gmail.com>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > Cc: Ondrej Zary <linux@rainbow-software.org>
> > > Cc: devel@driverdev.osuosl.org
> > > ---
> > >  drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > This, and your other patches, are all not necessary in Linus's tree
> > right now, right?  I thought I already sent them to him.
> > 
> > Or am I mistaken?
> 
> Oh, some of them really are. My apologies!
> Only the one (nonstaging one) is still needed:
> 
>     'pti: fix build failure'

Yes, I still have that queued up in my todo inbox somewhere, thanks.

greg k-h

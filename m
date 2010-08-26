Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0H0AA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:00:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:58825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0H0AAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:24 -0400
Date: Thu, 26 Aug 2010 16:02:31 -0700
From: Greg KH <gregkh@suse.de>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100826230231.GA12060@suse.de>
References: <20100824231241.GA6971@suse.de> <20100825005152.40ba2f12@lxorguk.ukuu.org.uk> <20100825004134.GA28884@suse.de> <20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk> <20100825155716.GB16284@suse.de> <20100825181108.1dcd0d80@lxorguk.ukuu.org.uk> <20100825171045.GA19401@suse.de> <20100825191437.1df57c9d@lxorguk.ukuu.org.uk> <20100825181647.GA22018@suse.de> <1282843484.2440.23.camel@itpsd6lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282843484.2440.23.camel@itpsd6lap>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 07:24:44PM +0200, Samo Pogacnik wrote:
> On 25.08.2010 (sre) at 11:16 -0700 Greg KH wrote:
> > On Wed, Aug 25, 2010 at 07:14:37PM +0100, Alan Cox wrote:
> > > > > > That's one extra process, not that much, right?
> > > > > 
> > > > > About 150K or so way too much and its not robust.
> > > > 
> > > > Fair enough.  So, with this driver, would it make sense for the distros
> > > > to switch over to using it instead of the above line in their initrd?
> > > 
> > > Distros no - I doubt any normal PC distro would turn the facility on.
> > > Embedded - yes especially deeply embedded.
> > 
> > So should this be dependent on CONFIG_EMBEDDED then?
> > 
> 
> Should i resend the patch with CONFIG_EMBEDDED dependency enabled? I do
> not have any real objections to that, except that the driver operates
> the same way regardless of the (non-)embedded configuration.

No, I can change it when I apply the patch next week (sorry, swamped at
the moment.)

thanks,

greg k-h

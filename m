Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0HYSTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:19:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:47025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0HYSTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:19:42 -0400
Date: Wed, 25 Aug 2010 11:16:47 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100825181647.GA22018@suse.de>
References: <20100824225703.GA5913@suse.de>
 <20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
 <20100824231241.GA6971@suse.de>
 <20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
 <20100825004134.GA28884@suse.de>
 <20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk>
 <20100825155716.GB16284@suse.de>
 <20100825181108.1dcd0d80@lxorguk.ukuu.org.uk>
 <20100825171045.GA19401@suse.de>
 <20100825191437.1df57c9d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825191437.1df57c9d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 07:14:37PM +0100, Alan Cox wrote:
> > > > That's one extra process, not that much, right?
> > > 
> > > About 150K or so way too much and its not robust.
> > 
> > Fair enough.  So, with this driver, would it make sense for the distros
> > to switch over to using it instead of the above line in their initrd?
> 
> Distros no - I doubt any normal PC distro would turn the facility on.
> Embedded - yes especially deeply embedded.

So should this be dependent on CONFIG_EMBEDDED then?

thanks,

greg k-h

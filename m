Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0HZRZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:25:04 -0400
Received: from smtp-good-out-1.t-2.net ([84.255.208.43]:53212 "EHLO
	smtp-good-out-1.t-2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0HZRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:25:01 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
In-Reply-To: <20100825181647.GA22018@suse.de>
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
	 <20100825181647.GA22018@suse.de>
Content-Type: text/plain
Date: Thu, 26 Aug 2010 19:24:44 +0200
Message-Id: <1282843484.2440.23.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.2010 (sre) at 11:16 -0700 Greg KH wrote:
> On Wed, Aug 25, 2010 at 07:14:37PM +0100, Alan Cox wrote:
> > > > > That's one extra process, not that much, right?
> > > > 
> > > > About 150K or so way too much and its not robust.
> > > 
> > > Fair enough.  So, with this driver, would it make sense for the distros
> > > to switch over to using it instead of the above line in their initrd?
> > 
> > Distros no - I doubt any normal PC distro would turn the facility on.
> > Embedded - yes especially deeply embedded.
> 
> So should this be dependent on CONFIG_EMBEDDED then?
> 

Should i resend the patch with CONFIG_EMBEDDED dependency enabled? I do
not have any real objections to that, except that the driver operates
the same way regardless of the (non-)embedded configuration.

regards, Samo


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2FZQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:26:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55044 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2FZQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:26:34 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 26 Jun 2012 09:26:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Anton Arapov <anton@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Kerneloops.org defunct?
Message-ID: <20120626162648.GA14941@roeck-us.net>
References: <CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
 <20110826173517.7321c086@lxorguk.ukuu.org.uk>
 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
 <20120625180536.GA29261@roeck-us.net>
 <4FE8A9C0.3050802@linux.intel.com>
 <20120625191233.GA29324@roeck-us.net>
 <20120626071430.GA16299@bandura.brq.redhat.com>
 <4FE9B646.9050706@linux.intel.com>
 <20120626142949.GA14890@roeck-us.net>
 <20120626143135.GC20573@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626143135.GC20573@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 04:31:35PM +0200, Anton Arapov wrote:
> On Tue, Jun 26, 2012 at 07:29:49AM -0700, Guenter Roeck wrote:
> > On Tue, Jun 26, 2012 at 06:16:54AM -0700, Arjan van de Ven wrote:
> > > On 6/26/2012 12:14 AM, Anton Arapov wrote:
> > > >   All in all, it seems to be optimistic so far, and I hope we will
> > > > have some web gui this summer. Although we don't have much oopses
> > > > reported yet and changing the ip address of kerneloops.org, as
> > > > mentioned before, might help.
> > > 
> > > this is the problem indeed. When Fedora stopped submitting oopses to
> > > kerneloops.org, the project became suddenly of much much less value.
> > > (this was well before the kernel.org issues)
> > Is this still an issue ? I thought Anton's change was made to the Fedora
> > package, though I may be wrong. Either case, Anton might have some influence at
> > Fedora.
> 
>   My understanding was - kerneloops.org just shutted down gradually,
> it was slow at the beginning and off now. I didn't expect nor know
> Fedora stopped reporting.

Maybe it was a combination of factors. I have seen complaints from people that
kerneloops reports did not show up on kerneloops.org, and complaints that fedora
stopped submitting requests. Maybe the system was overloaded at times, or maybe
some default was changed. I noticed that Ubuntu comes with the kerneloops
daemon installed, but that it is disabled by default. Not really helpful, since
many typical Ubuntu user will not even know that it exists in the first place.
Maybe something similar happened with Fedora ?

Either case, I think it would be great to get it working again, and then work
with the main distributions to get reports submitted.

Thanks,

Guenter

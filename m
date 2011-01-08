Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1AHQTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:19:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:57359 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1AHQTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:19:23 -0500
Date: Sat, 8 Jan 2011 08:11:56 -0800
From: Greg KH <gregkh@suse.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: On Linux numbering scheme
Message-ID: <20110108161156.GB16090@suse.de>
References: <AANLkTik_pa7ac4iQAyU7JeUej7qfkAvYQTru7n0-mZAt@mail.gmail.com>
 <32869803.14581294498166043.JavaMail.root@mail-zbox20.bo3.lycos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32869803.14581294498166043.JavaMail.root@mail-zbox20.bo3.lycos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 09:49:26AM -0500, Artem S. Tashkinov wrote:
> ----- "Geert Uytterhoeven" <geert@linux-m68k.org> wrote:
> 
> > On Thu, Jan 6, 2011 at 09:31, Claudio Scordino
> > <claudio@evidence.eu.com> wrote:
> > >>   As time passes by, the Linux numbering scheme makes even less
> > sense.
> > >>   Some time ago there was a discussion on LKML about a new
> > numbering
> > >>   scheme but it didn't come to any positive conclusion and then
> > the
> > >>   subject was forgotten entirely. Not meaning to raise a clamour
> > here
> > >>   (and I suppose I represent a large group of Linux users here).
> > I'm
> > >>   willing to suggest a numbering scheme which I hope will answer
> > all
> > >>   known complaints and criticism.
> > >
> > > This seems to be a periodically recurrent topic on the list.
> > >
> > > If I've correctly understood all points of view, there are currently
> > two
> > > groups of developers:
> > >
> > > 1. Those who want to maintain the current numbering scheme, because
> > they
> > > feel comfortable with it, and because they can easily understand
> > the
> > > number of releases between one release and another.
> > >
> > > 2. Those who prefer having a scheme somehow related to the date, so
> > they
> > > can easily understand when a certain kernel has been released (i.e.
> > how
> > > "old" it is).
> > >
> > > Does really exist a numbering scheme that can satisfy both groups
> > of
> > > people ? Probably not.
> > >
> > > My only idea would be to maintain the usual numbering scheme, and
> > just
> > > replace the second number (6) with the year of release.
> > >
> > > For example:
> > >
> > >        2.6.36 would be 2.10.36
> > >
> > >        2.6.37 would be 2.11.37
> > >
> > >        2.6.38 would be 2.11.38
> > >
> > >        and so on...
> > >
> > > This way, you put some information about the year of release
> > without
> > > loosing all the benefits of the current scheme.
> > >
> > > But this means having two independent incremental numbers, which
> > maybe
> > > is a too insane scheme.
> > 
> > Then why not drop the leading "2." completely?
> > 
> 
> This will break too many user space scripts/applications which expect
> 2.x.x.x numbers.

What userspace scripts/applications expect numbers like that?  How do
they handle releases like what Linus just did (2.6.37)?

thanks,

greg k-h

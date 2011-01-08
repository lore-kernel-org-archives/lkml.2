Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1AHOtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:49:39 -0500
Received: from mail-zbox20.bo3.lycos.com ([209.202.250.20]:48002 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1AHOti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:49:38 -0500
Date: Sat, 8 Jan 2011 09:49:26 -0500 (EST)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Claudio Scordino <claudio@evidence.eu.com>
Message-ID: <32869803.14581294498166043.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <AANLkTik_pa7ac4iQAyU7JeUej7qfkAvYQTru7n0-mZAt@mail.gmail.com>
Subject: Re: On Linux numbering scheme
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [178.46.203.148]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Geert Uytterhoeven" <geert@linux-m68k.org> wrote:

> On Thu, Jan 6, 2011 at 09:31, Claudio Scordino
> <claudio@evidence.eu.com> wrote:
> >>   As time passes by, the Linux numbering scheme makes even less
> sense.
> >>   Some time ago there was a discussion on LKML about a new
> numbering
> >>   scheme but it didn't come to any positive conclusion and then
> the
> >>   subject was forgotten entirely. Not meaning to raise a clamour
> here
> >>   (and I suppose I represent a large group of Linux users here).
> I'm
> >>   willing to suggest a numbering scheme which I hope will answer
> all
> >>   known complaints and criticism.
> >
> > This seems to be a periodically recurrent topic on the list.
> >
> > If I've correctly understood all points of view, there are currently
> two
> > groups of developers:
> >
> > 1. Those who want to maintain the current numbering scheme, because
> they
> > feel comfortable with it, and because they can easily understand
> the
> > number of releases between one release and another.
> >
> > 2. Those who prefer having a scheme somehow related to the date, so
> they
> > can easily understand when a certain kernel has been released (i.e.
> how
> > "old" it is).
> >
> > Does really exist a numbering scheme that can satisfy both groups
> of
> > people ? Probably not.
> >
> > My only idea would be to maintain the usual numbering scheme, and
> just
> > replace the second number (6) with the year of release.
> >
> > For example:
> >
> >        2.6.36 would be 2.10.36
> >
> >        2.6.37 would be 2.11.37
> >
> >        2.6.38 would be 2.11.38
> >
> >        and so on...
> >
> > This way, you put some information about the year of release
> without
> > loosing all the benefits of the current scheme.
> >
> > But this means having two independent incremental numbers, which
> maybe
> > is a too insane scheme.
> 
> Then why not drop the leading "2." completely?
> 

This will break too many user space scripts/applications which expect
2.x.x.x numbers.

Best wishes,

Artem

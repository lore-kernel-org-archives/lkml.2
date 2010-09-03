Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0ICMN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:13:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab0ICMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:13:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: mhw@wittsend.com
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 14:13:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100831104205.GA2301@bitwizard.nl> <1283440567.5202.19.camel@canyon.wittsend.com>
In-Reply-To: <1283440567.5202.19.camel@canyon.wittsend.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031413.00266.arnd@arndb.de>
X-Provags-ID: V02:K0:D6CsEGtj9WNZ81WB6cZi0y8YHyAPLQUtEYmzxx1USGD
 MMeLMnnOIHOvkrgWIY71RyXNE5AXvRij1pb2qv08H1NHDAsdHY
 lUQrMCdz2DlTmezDe647OXj6iqPIwvNe74op+M+qpAfuOfgDjt
 wPmIhp8Vsp9m2ExYBVNVfQ9BI6QQwJEQRN+OxZkInTm6p3onDH
 LGOTDFl395a1/qjIMr2xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 September 2010, Michael H. Warfield wrote:
> On Tue, 2010-08-31 at 12:42 +0200, Rogier Wolff wrote: 
> > The question is whether I want the drivers I wrote to stay or to
> > go away?
> 
> > I was paid years ago to make Linux support the Specialix cards. It
> > started with one card from their line of "solutions", but the others
> > followed.
> 
> My story is very similar with the Computone Intelliport II boards.  I
> was paid (in hardware) by Computone to get their drivers integrated into
> the mainline kernel and support them.  That was a long long time ago.
> The boards have not been manufactured in over a decade and the company
> went of of business a long time ago.  I'm still in touch with several of
> the old developers that use to work there.

Ok, so it sounds both of you successfully managed to maintain the device
drivers way beyond the life time of the hardware, great work!

Let's send the drivers into their well-earned retirement in drivers/staging
where they can die from a natural cause. If someone still has a use for
them after all, we can always bring them back and he or she can become
the new maintainer ;-).

	Arnd

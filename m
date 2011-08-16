Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1HPPS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:18:57 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35564 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1HPPSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:18:54 -0400
Date: Tue, 16 Aug 2011 17:18:29 +0200
From: Florian Mickler <florian@mickler.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
        Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
Message-ID: <20110816171829.2229c18d@schatten.dmk.lab>
In-Reply-To: <20110815131213.c66a9e61.rdunlap@xenotime.net>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
	<CACqU3MU-T2cftzSqufFGpYJYeiC0Vbipf+LtpBrJD4RVdef2AQ@mail.gmail.com>
	<20110815131213.c66a9e61.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 13:12:13 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Mon, 15 Aug 2011 14:36:41 -0400 Arnaud Lacombe wrote:
> 
> > Hi,
> > 
> > On Fri, Jul 29, 2011 at 9:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > > From: Randy Dunlap <rdunlap@xenotime.net>
> > >
> > > Introduce "Internal-reference-ID:" for company-internal
> > > patch tracking.  Also clarify that URLs in patches should be
> > > public, not private.
> > >
> > > Based on emails from Greg Kroah-Hartman.
> > >
> > > Internal-reference-ID: rdunlap.2011.0729.id1
> > >
> > What's the point of this for individuals ? Couldn't the Message-id
> > from the mail be re-used ?
> > 
> >  - Arnaud
> 
> Individuals or companies might like to track their upstream patches
> easily.  A pseudo-random message-id doesn't do that (for me).

Also when parsing the changelog it is nice to be able to skip those
lines by common prefix. Without prefix you can easily get
trapped by the <id-text> having similar patterns to what you look
for. 

Regards,
Flo

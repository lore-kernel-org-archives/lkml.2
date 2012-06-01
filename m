Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2FALjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 07:39:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40483 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2FALjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 07:39:12 -0400
Date: Fri, 1 Jun 2012 12:41:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Greg KH <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>,
        Michael =?ISO-8859-1?B?QvxzY2g=?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
Message-ID: <20120601124149.09a04890@pyramind.ukuu.org.uk>
In-Reply-To: <CAFU-uVupiK5O-LC=wA3Tte78hjzwSJSwUGLb2-58VJSs5z0_hQ@mail.gmail.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
	<20120516143830.GA483@kroah.com>
	<alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
	<CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
	<20120516150813.GA3293@kroah.com>
	<CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
	<CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
	<1338492342.5861.23.camel@joe2Laptop>
	<20120531201502.GA30000@ZenIV.linux.org.uk>
	<CAFU-uVupiK5O-LC=wA3Tte78hjzwSJSwUGLb2-58VJSs5z0_hQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 10:41:06 +0200
Philipp Riemer <ruderphilipp@gmail.com> wrote:

> 2012/5/31 Al Viro <viro@zeniv.linux.org.uk>:
> > On Thu, May 31, 2012 at 12:25:42PM -0700, Joe Perches wrote:
> >
> >> -Al Viro <viro@ftp.linux.org.uk>
> >> -Al Viro <viro@zenIV.linux.org.uk>
> >> []
> >> +Alexander Viro <viro@ftp.linux.org.uk>
> >>
> >> I think I've never seen that name before.
> >
> > *snort*
> >
> > Same thing, but I prefer to go by the former variant (and I normally
> > use zeniv.linux.org.uk for s-o-b, etc.)
> I changed your name to the short form in the current version of the
> .mailmap file at my Github repository.
> Does your comment in parentheses mean that your "ftp.linux.org.uk" and
> "www.linux.org.uk" addresses
> (c|sh)ould be mapped onto "zeniv.linux.org.uk"?

www.linux.org.uk addresses shouldn't exist in the file at all. That's now
a website part of the Linux Foundation.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2GZWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:53:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49643 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2GZWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:53:16 -0400
Date: Thu, 26 Jul 2012 23:56:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: No big TTY/serial patch merge for 3.6-rc1
Message-ID: <20120726235651.28a44eb1@pyramind.ukuu.org.uk>
In-Reply-To: <20120726212807.GA9049@kroah.com>
References: <20120726190814.GA2194@kroah.com>
	<20120726222313.5993a550@pyramind.ukuu.org.uk>
	<20120726212807.GA9049@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 14:28:07 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Jul 26, 2012 at 10:23:13PM +0100, Alan Cox wrote:
> > On Thu, 26 Jul 2012 12:08:14 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > >       tty: Move the handling of the tty release logic
> > 
> > Can we lose that one specifically. I've chased down Ian Abbotts problem
> > and replicated it and that is the offending patch not the lock localise
> > (which still needs to be kept out as it depends upon this one)
> > 
> > I have it fixed but it's not had enough testing for -rc1 and moving the
> > termios data has enough spectacular hits all drivers fallout for 3.6
> 
> Yes, I can go revert it.  I'm working on building up a small tty-linus
> branch at the moment for just the "must haves" for 3.6.  Right now it's
> just 10 patches listed below.  Any objection to me sending these after
> a round trip through linux-next?

All look good to me

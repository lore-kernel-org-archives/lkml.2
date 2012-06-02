Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab2FBLxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:53:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41556 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab2FBLxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:53:54 -0400
Date: Sat, 2 Jun 2012 12:57:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120602125723.5b057570@pyramind.ukuu.org.uk>
In-Reply-To: <1338624102.2760.1693.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	<1338402812.2760.413.camel@edumazet-glaptop>
	<4FC66D3D.6080509@fusionio.com>
	<1338404902.2760.451.camel@edumazet-glaptop>
	<1338410107.2760.544.camel@edumazet-glaptop>
	<1338456918.2760.1318.camel@edumazet-glaptop>
	<1338574627.2760.1545.camel@edumazet-glaptop>
	<CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	<1338583498.2760.1648.camel@edumazet-glaptop>
	<20120601215620.305155c0@pyramind.ukuu.org.uk>
	<1338584389.2760.1653.camel@edumazet-glaptop>
	<1338621438.2760.1679.camel@edumazet-glaptop>
	<1338623708.2760.1691.camel@edumazet-glaptop>
	<1338624102.2760.1693.camel@edumazet-glaptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Jun 2012 10:01:42 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Sat, 2012-06-02 at 09:55 +0200, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > On Sat, 2012-06-02 at 09:17 +0200, Eric Dumazet wrote:
> > 
> > > 
> > > Here is the patch I am currently testing (need to boot the machine ~50
> > > times to make sure it is the right fix)
> > 
> > Seems good, but am still doing reboots to make sure.
> 
> Nope, still get a crash at 15th boot.
> 
> I have to run.

I'll have a look at this ASAP - I think the driver ref counting side is a
red herring but I'll build an Ubuntu 12 setup and try and replicate the
crash once I'm back at work (its a national holiday here Sat-Tue for the
English queens jubilee)

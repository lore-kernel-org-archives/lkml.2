Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0LEPMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 10:12:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35093 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0LEPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 10:12:38 -0500
Date: Sun, 5 Dec 2010 15:12:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Regression: sched: automated per session task groups
Message-ID: <20101205151220.0c532c94@pyx>
In-Reply-To: <idfrvp$l4o$1@dough.gmane.org>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	<AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	<idfrvp$l4o$1@dough.gmane.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As soon as you do that from the same terminal that you're going to
> > launch the "make" from, you're back to total lossage.  Are you going
> > to explain to a student that "oh, you need to create a new
> > gnome-terminal tab and launch firefox from that"?
> 
> Btw, most people don't do that anymore.  They don't use terminals.  They 

Its a regression for those who do - and often have good reason to do.
This is of course why you don't put policy in the kernel and the original
patch was bogus anyway.

> To have a fluid desktop one shouldn't require to hack with terminal 
> commands.

Which is the classic mentality that ruins the big bloated GNOME Linux
desktop "It works my way and every other way is wrong so go screw". Of
course the other half of the problem is exactly that - firefox was once a
small browser, its now a bloated monster too so the scheduler is quite
sensible to pick on it.

Alan

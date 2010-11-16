Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0KPRWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:22:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42190 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755811Ab0KPRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:21:59 -0500
Date: Tue, 16 Nov 2010 17:20:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Schulte <matts@commtech-fastcom.com>
Cc: Pavel Machek <pavel@ucw.cz>, Claudio Scordino <claudio@evidence.eu.com>,
        Greg KH <gregkh@suse.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-serial@vger.kernel.org,
        Grant Edwards <grant.b.edwards@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20101116172013.102e06a6@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=grehSnfWzCDtSXXmNb=-NAwbHHJ_P1XPyOuw8@mail.gmail.com>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
	<4CBD8EE4.5040808@evidence.eu.com>
	<i9ka0s$4ua$1@dough.gmane.org>
	<201010191727.53314.alexander.stein@systec-electronic.com>
	<i9kk4o$svc$1@dough.gmane.org>
	<4CC418A9.6090602@evidence.eu.com>
	<4CDA630F.4060903@atmel.com>
	<20101110172842.GC12371@suse.de>
	<4CDBC3EC.6020707@evidence.eu.com>
	<20101116143016.GB6527@ucw.cz>
	<AANLkTi=grehSnfWzCDtSXXmNb=-NAwbHHJ_P1XPyOuw8@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 10:13:22 -0600
Matt Schulte <matts@commtech-fastcom.com> wrote:

> On Tue, Nov 16, 2010 at 8:30 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> Documentation about RS485 serial communications
> >
> > I have seen hardware (kontron pmc-6l) that was capable of switching
> > between RS232, RS485 and one other standard by software.
> >
> > Is such hw common? If so, should we have standard interface?
> 
> In my opinion this type of card is not that common.  Generally
> speaking the achievable baud rates for this type of multi-protocol
> card are very limited because of limitations of the transceiver chips.
>  It seems that most of the time people would rather have a faster
> serial port than one that does several different voltages

If there are two types in common use then thats enough to say we should
have a common interface IMHO

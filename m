Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0ICUSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:18:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39260 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752537Ab0ICUSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:18:15 -0400
Date: Fri, 3 Sep 2010 21:32:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100903213203.54f69adc@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimjaqakjEhNc0nVSzfNPSwYtjYXmmOsxuh+iMjC@mail.gmail.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<20100830184737.GA21339@suse.de>
	<201008302333.22447.arnd@arndb.de>
	<201009031729.58102.arnd@arndb.de>
	<AANLkTimjaqakjEhNc0nVSzfNPSwYtjYXmmOsxuh+iMjC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 22:08:38 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, Sep 3, 2010 at 17:29, Arnd Bergmann <arnd@arndb.de> wrote:
> > amiserial,nozomi,synclink,
> > rocket,ipwireless
> > cyclades,moxa,mxser,
> > isicom,bfin_jtag_comm   -> drivers/tty/
> >
> > stallion,istallion,
> > epca,specialix,ip2,
> > riscom,serial167        -> drivers/staging/tty/*
> 
> I thought we wanted to keep serial167 alive as long as it builds?

Does it build ? Is it secure ? I was under the impression the answer in
both cases was no.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0HYTNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:13:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50121 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216Ab0HYTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:13:38 -0400
Date: Wed, 25 Aug 2010 20:30:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100825203042.09d0b1af@lxorguk.ukuu.org.uk>
In-Reply-To: <20100825181647.GA22018@suse.de>
References: <20100824225703.GA5913@suse.de>
	<20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
	<20100824231241.GA6971@suse.de>
	<20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
	<20100825004134.GA28884@suse.de>
	<20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk>
	<20100825155716.GB16284@suse.de>
	<20100825181108.1dcd0d80@lxorguk.ukuu.org.uk>
	<20100825171045.GA19401@suse.de>
	<20100825191437.1df57c9d@lxorguk.ukuu.org.uk>
	<20100825181647.GA22018@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 11:16:47 -0700
Greg KH <gregkh@suse.de> wrote:

> On Wed, Aug 25, 2010 at 07:14:37PM +0100, Alan Cox wrote:
> > > > > That's one extra process, not that much, right?
> > > > 
> > > > About 150K or so way too much and its not robust.
> > > 
> > > Fair enough.  So, with this driver, would it make sense for the distros
> > > to switch over to using it instead of the above line in their initrd?
> > 
> > Distros no - I doubt any normal PC distro would turn the facility on.
> > Embedded - yes especially deeply embedded.
> 
> So should this be dependent on CONFIG_EMBEDDED then?

No objection to that

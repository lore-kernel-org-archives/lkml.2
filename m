Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1ECU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:26:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47671 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754621Ab1ECU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:26:36 -0400
Date: Tue, 3 May 2011 21:27:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Intel SST driver update
Message-ID: <20110503212749.1d72f9b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503184032.GK1762@opensource.wolfsonmicro.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
	<20110503171538.GH2893@sirena.org.uk>
	<20110503193612.22833754@lxorguk.ukuu.org.uk>
	<20110503184032.GK1762@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, I was just asking if there was a plan to work on this properly -
> the normal expectation in staging is that we'll see in place refactoring
> and this series clearly isn't that.  You seem a little defensive here...

There I disagree (on both points). We have a collection of drivers in
staging some of which are in the 'refactor and move' category (eg SEP)
others of which are in the 'until the nice one is done' category - eg
much of the wireless stuff, rim4 and a few other drivers.

> > It might as well therefore be maintained in tree as out. That seems to
> > serve Linux users rather better.
> 
> Of course, as do most of us, I was mostly making sure that there was a
> plan here.

Yes there is a plan. SST essentially gets updated to fix stuff that needs
to work (eg runtime PM for Moorestown) but isn't the future. My favourite
sst patch is going to be the one which reads 'added 0 lines, removed
bazillions' because at that point it ceases to be my problem ;)

Alan

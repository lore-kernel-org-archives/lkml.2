Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1FSOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 10:16:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41837 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754067Ab1FSOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 10:16:56 -0400
Date: Sun, 19 Jun 2011 15:19:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110619151909.1403205d@lxorguk.ukuu.org.uk>
In-Reply-To: <201106191325.17181.arnd@arndb.de>
References: <20110618172537.GH3441@infomag.iguana.be>
	<201106182107.45682.arnd@arndb.de>
	<20110619110328.39c0f5e1@lxorguk.ukuu.org.uk>
	<201106191325.17181.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Then you'd need an additional interface to specify which watchdog as soon
> > as we support multiple watchdogs.
> 
> You can always have multiple ways of setting nowayout -- hardware requirements,
> global module option, local module option, and a new ioctl command -- but
> what is being used is then the logical OR of all of them.

An ioctl for it would make a lot of sense as watchdogs are often compiled
in so currently there isn't a good way to runtime set this.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1KKLzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:55:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36720 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107Ab1KKLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:55:09 -0500
Date: Fri, 11 Nov 2011 11:56:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: eth0/1 swapped places after kernel Upgrade 3.0.8 -> 3.1.0 (and
 udev 172 -> 174)
Message-ID: <20111111115617.4a352cc5@lxorguk.ukuu.org.uk>
In-Reply-To: <20111111114014.GA1962@andrews-imac.pitney-fabs>
References: <20111102101404.GA5195@andrew-xps.home>
	<20111111114014.GA1962@andrews-imac.pitney-fabs>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011 11:40:15 +0000
Andrew Walrond <andrew@walrond.org> wrote:

> On Wed, Nov 02, 2011 at 10:14:04AM +0000, Andrew Walrond wrote:
> > Not sure if this is a udev or kernel issue, or indeed whether I
> >  should expect these devices to have persistent naming at all
> >  without some udev configuration of my own, but I thought I'd
> >  report it just in case it's useful.
> > 
> > Output from lspci:
> > 
> > 03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > 07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > 
> 
> It's worse than I thought; eth0/eth1 are randomly swapping places on boot.
> Is this likely to be a kernel or udev problem?

The kernel probes them in whatever order it walks the PCI bus. What udev
does afterwards is a distro question.

Does the order of the two probe reports every change or just the final
udev result  - ie are they always found mac xx:xx:03 then xx:xx:05 ?

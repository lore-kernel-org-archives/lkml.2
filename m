Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0KUOJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:09:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45162 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753709Ab0KUOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:09:03 -0500
Date: Sun, 21 Nov 2010 14:07:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sep: Introduce sep driver
Message-ID: <20101121140757.66681d35@lxorguk.ukuu.org.uk>
In-Reply-To: <20101120162726.GA29623@kroah.com>
References: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com>
	<20101120123911.356bc780@lxorguk.ukuu.org.uk>
	<20101120162726.GA29623@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Nov 2010 08:27:26 -0800
Greg KH <greg@kroah.com> wrote:

> On Sat, Nov 20, 2010 at 12:39:11PM +0000, Alan Cox wrote:
> > 
> > 
> > > +/* rar handler */
> > > +#ifndef CONFIG_MRST_RAR_HANDLER
> > > +
> > > +/* This stub header is for non Moorestown driver only */
> > 
> > What happened to the patches I sent you a while back that cleaned this
> > one up ?
> 
> Wait, this isn't the cleaned up version?  Ick, should I just drop it and
> wait for a working one instead?  Or Mark, are you going to fix this one
> up for real this time?

I sent Mark a set of follow on patches. Dunno if they got lost in part or
not. No big deal as they applied on top of his previous set so can just
be applied as a follow up to the merge.

So I'd rather you carried on merging them and we'll figure out which of
the other bits need dropping on top.

Alan

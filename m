Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411Ab2FVRAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:00:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40936 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2FVRAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:00:37 -0400
Date: Fri, 22 Jun 2012 18:04:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 09/12] commit 22126843cb3c2a782c2d52614486115f3e9db478
Message-ID: <20120622180423.24c0001b@pyramind.ukuu.org.uk>
In-Reply-To: <20120622153657.GB6081@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
	<20120622154438.1405.43658.stgit@localhost.localdomain>
	<20120622153657.GB6081@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 08:36:57 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 22, 2012 at 04:44:59PM +0100, Alan Cox wrote:
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > tty: move the termios object into the tty
> > 
> >     This will let us sort out a whole pile of tty related races. The
> >     alternative would be to keep points and refcount the termios objects.
> >     However
> >     1. They are tiny anyway
> >     2. Many devices don't use the stored copies
> >     3. We can remove a pty special case
> > 
> >     Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Odd subject line, and formatting, did something go wrong with your
> scripts?

Apparently so. I will given them a stern talking to and repost

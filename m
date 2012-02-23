Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2BWWyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:54:10 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40800 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2BWWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:54:08 -0500
Date: Thu, 23 Feb 2012 22:56:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own
 locking
Message-ID: <20120223225602.747c31df@pyramind.ukuu.org.uk>
In-Reply-To: <1330029747.20389.37.camel@pasglop>
References: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
	<1330029747.20389.37.camel@pasglop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 07:42:27 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2012-02-23 at 13:39 +0000, Alan Cox wrote:
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > The driver appears to be terminall broken, if nobody is maintaining it then
> > perhaps it should go into staging and the out-tray.
> 
> Hrm, I don't think anybody maintains it but I do have a BriQ somewhere
> in storage, so I suppose I could pick it up, not that I need another
> crap driver to deal with right now though...

In which case can we just stuff it into the tree, or take the briq driver
out into staging as this is the last blocker on tackling the tty_lock
entirely in the tty layer

Alan

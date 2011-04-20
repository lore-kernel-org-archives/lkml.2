Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1DTVUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:20:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39716 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651Ab1DTVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:20:14 -0400
Date: Wed, 20 Apr 2011 22:21:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] gma500: add the ability to request backed space or
 not
Message-ID: <20110420222108.38bc8587@lxorguk.ukuu.org.uk>
In-Reply-To: <20110420203117.GA14141@kroah.com>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
	<20110419142658.16479.59689.stgit@localhost.localdomain>
	<20110420203117.GA14141@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 13:31:17 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Apr 19, 2011 at 03:27:10PM +0100, Alan Cox wrote:
> > We will will need this for doing a GEM allocator. It should also avoid any
> > crashes with the current code if the stolen area is too small.
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> What tree did you make this against?

Against -next and the previous patches I sent you. Have you been
stripping white space automatically again. That will break follow up
patches if so.

I'll try and take a look at it at some point but it may well be mid May.

Alan

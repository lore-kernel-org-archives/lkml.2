Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab1KIXYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:24:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54243 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab1KIXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:24:38 -0500
Date: Wed, 9 Nov 2011 23:25:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109232533.16780313@lxorguk.ukuu.org.uk>
In-Reply-To: <20111109231124.GC17769@opensource.wolfsonmicro.com>
References: <20111109121329.GC21630@sirena.org.uk>
	<1320854413.32205.948.camel@vkoul-udesk3>
	<20111109164211.GA4016@opensource.wolfsonmicro.com>
	<20111109165518.GA13451@kroah.com>
	<20111109165829.GC4016@opensource.wolfsonmicro.com>
	<20111109173037.66bea268@lxorguk.ukuu.org.uk>
	<20111109225933.GA17769@opensource.wolfsonmicro.com>
	<20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
	<20111109230329.GB17769@opensource.wolfsonmicro.com>
	<20111109230558.2fb94c0b@lxorguk.ukuu.org.uk>
	<20111109231124.GC17769@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011 23:11:24 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Nov 09, 2011 at 11:05:58PM +0000, Alan Cox wrote:
> 
> > Yes - then it doesn't compile. The codec is calling functions defined in
> > that header. I don't think you need much of it but both bits of that
> > driver are using some of the stuff.
> 
> Oh, actually the mainline CODEC driver doesn't have any such staging
> references in it at all.  I don't know what tree you're patching
> against?

Sorry I did the patches against the tree I had handy, that had some other
SoC audio bits in it so ignore them.

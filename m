Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1K1NRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:17:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53799 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab1K1NRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:17:23 -0500
Date: Mon, 28 Nov 2011 13:18:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20111128131847.48bffb93@lxorguk.ukuu.org.uk>
In-Reply-To: <20111129001353.399142710ab77822b29552f0@canb.auug.org.au>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
	<20111128135317.a99880b234c6c060a622fa31@canb.auug.org.au>
	<20111128113056.2099e4c3@lxorguk.ukuu.org.uk>
	<20111129001353.399142710ab77822b29552f0@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well its very hard to sort stuff out when you are juggling a cross tree
> > set of dependancies and someone pointlessly stops one of them being
> > visible in next for ten days.
> 
> The mess in the drm tree has nothing to do with the staging tree. 

I would suggest you re-read the paragraph above, and the mails I sent you
about marking the staging gma500 tree broken (which given nothing
happened in response to any of them I imagine you didn't).

And if you still think that blocking the DRM tree from -next for ten days
thus stopping all sorts of other integration work and forcing people's
hands on moving from staging and the like didn't cause the problems and
is the right policy then we'll just have to agree to differ.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0KJAXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:23:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58873 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418Ab0KJAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:23:12 -0500
Date: Wed, 10 Nov 2010 00:21:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101110002153.7af92a1f@lxorguk.ukuu.org.uk>
In-Reply-To: <20101109235314.GD5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
	<20101109185604.GK5876@outflux.net>
	<20101109225000.1b90e720@lxorguk.ukuu.org.uk>
	<20101109235314.GD5876@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only Intel has this problem (it's the only CPU that defines this MSR), so
> that'll reduce it. But Google is of no help to me on this; where can I find
> these documents?

www.intel.com 8)


> > I'm not specifically aware of any but I do know for example that there
> > are other CPU BIOS disablable features that some systems disable in the
> > BIOS for good reason (an ancient example being the original Pentium
> > REP MOVS optimisation on some steppings)
> 
> By definition there should be fewer errata CPUs than those than need their
> BIOS ignored, so I still think this patch makes sense (especially since it
> can trivially be worked around with the noexec=off boot option).

We need to be sure because the last thing you want is even 1% of your 10%
of users to sudden get magical random memory corruption from overriding
something wrongly !

It's definitely worth checking and worth doing because even if there is
one (and I have no idea if there is) it'll tell you which steppings

Alan

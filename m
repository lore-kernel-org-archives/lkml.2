Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2DTXMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:12:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50460 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2DTXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:12:28 -0400
Date: Sat, 21 Apr 2012 00:14:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Chandra Seetharaman <sekharan@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Message-ID: <20120421001433.2955abd4@pyramind.ukuu.org.uk>
In-Reply-To: <20120420225822.GA10769@redhat.com>
References: <20111215214440.GA17677@redhat.com>
	<4EF039D5.5010201@suse.de>
	<20120405144721.GA18437@redhat.com>
	<20120420144538.GB8155@redhat.com>
	<20120420173405.GA8846@redhat.com>
	<20120420214120.159e2690@pyramind.ukuu.org.uk>
	<20120420215825.GA10406@redhat.com>
	<20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
	<20120420225822.GA10769@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure Alan, seize on "proprietary" and "EXPORT_SYMBOL_GPL".. and gloss
> right over the fact that what is being proposed is reasonable.

I suggest you read the licence document.

> Any multipath driver should be able to detach a scsi_dh module.  As is
> evidenced by the fact that they can already make use of sysfs to do so.

They can call the _GPL version if they are GPL, so there is no problem.

> Relaxing the scsi_dh_detach interface makes it easier for a long
> standing proprietary driver to get out of Linux's way.

So we are back to this being for a proprietary driver trying to link with
GPL code.

> _Upstream_ has kept it that way because we've been concerned about
> breaking PowerPath in enterprises where Linux is deployed.  Upstream has
> been good citizens to the fault of Linux.

Not from where I am standing. It sounds like upstream has suffered for
the benefit of a dubious proprietary module.

> > I'm a rights holder. Domain expertise isn't relevant here. The code I
> > provided is licensed under the GPL. Whether the symbol is EXPORT_SYMBOL
> > or EXPORT_SYMBOL_GPL any derivative code (eg code that requires the
> > kernel be modified to match it) cannot call it.
> 
> Remind me again when you ever developed anything to do with scsi_dh?

It's part of the same kernel. It's GPL code. You can take your own code
and relicense it to be non GPL if you wish, but not mine nor Greg's nor
anyone elses.

> To be clear: PowerPath doesn't _need_ this.  Not even close.

Then we don't need to apply it ? Thank you for clarifying that.

> Linux is improved by not having to walk on egg shells that attaching a
> helpful linux-only layer in kernel will somehow screw up some 3rd party
> software that a customer values.

That's a problem for Red Hat. Don't dump it on upstream. If the kernel
would work better with scsi_dh always attached we should always attach
it. It's the problem of the out of tree people how they cope. They'll
figure something out.

And you still have the same confusion

There is no "Linux only" magic in _GPL. Any derivative work of a GPL work
must be distributed under the GPL.

> You still don't get it... yet you'll saber rattle behind generic GPL
> lawyer-up nonsense.

This has gone far enough but it seems your management has already jumped
on it. Not my preferred way of handling such matters but Red Hat legal and
PR need to rein you in before you cause some serious damage.

Alan

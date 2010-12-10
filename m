Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0LJXne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:43:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42009 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916Ab0LJXnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:43:32 -0500
Date: Fri, 10 Dec 2010 23:42:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ltuikov@yahoo.com
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101210234253.28c5e76e@lxorguk.ukuu.org.uk>
In-Reply-To: <882104.74689.qm@web31813.mail.mud.yahoo.com>
References: <882104.74689.qm@web31813.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think people need to know.

I think they will judge themselves from the full discussion. I'm not sure
they'll vote in your favour however.

"So to expose the obvious, hypothetically, one of the resident "linux
kernel engineers/maintainers" could've submitted AN EMPTY DRIVER that
"binds to" the UAS id, and from then on, any other improvements would
have to go through them"

Strangely that doesn't work because the community isn't full of idiots,
in fact we actively select against them because anyone who is maintaining
a driver needs to be able to deal with other people (at least other
people who wish to be constructive).

"Do you not see HOW DIFFERENT the two drivers are? Do you not see the
difference in quality, presentation, etc, etc."

I find the presentation *very* different. I'm rather worried about the
manner in which it is being presented. Your driver may be the best on the
planet - who knows - but if your response to needing to work with people
is to accuse them of being part of some giant conspiracy or make offensive
comments then that's rapidly going to outweight the quality of the code
and you'll simply run out of people to talk to.

It's actually pretty hard to get in GregKH's kill file, and I suspect by
now you are in a few others as well. So perhaps you can find someone
working with you who has people skills and can sit between you and Greg
and other maintainers and make progress ? It won't be the first time a
user interface problem has been fixed that way in the Linux world.

But basically it's really simple. When we have an existing driver we work
from it - step by step from where we are, to where we want to be. That
series of steps should tell a story so anyone reading the patch series can
understand how it unfolded.

We also have a process for dealing with people not responding, and
irritating them enough they killfile you and refuse to deal with you
isn't that process, especially when you then get yourself killfiled by
the next maintainer up as well.

When you come along late and say "I've got this great other driver", then
sorry you missed the party - you could have submitted yours earlier and
the question becomes "how do I make the existing driver at least as cool
as the one that was too late" not "how do I replace it"

Alan

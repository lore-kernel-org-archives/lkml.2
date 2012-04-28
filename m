Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2D1VFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:05:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57789 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2D1VFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:05:31 -0400
Date: Sat, 28 Apr 2012 22:08:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Preston Fick <Preston.Fick@silabs.com>
Cc: Preston Fick <pffick@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120428220808.4674a8df@pyramind.ukuu.org.uk>
In-Reply-To: <00374F755A5C474884D69FBCA77349D105219FB334@EXCAUS002.silabs.com>
References: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
	<20120428190502.32eaf294@pyramind.ukuu.org.uk>
	<00374F755A5C474884D69FBCA77349D105219FB334@EXCAUS002.silabs.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand that this change is all over the place in this code, so I'm willing to change it back, and just use raw usb functions contained in the ones I modified. This should make it simpler and eliminate this problem.

I would suggest you split this into two patches then. The first patch
which changes the submission handling but nothing else, and a second
patch which adds the GPIO functions.

> Is there a better way to get this type of support for our devices? The reason I'm adding this here is because our customers need and use this functionality. The way we do this on Windows and Mac is through custom ioctl calls, so I assumed this would be the appropriate way to do this here as well.

I've Cc'd the linux-serial list as well to see what people think. I'd
like to avoid chip specific custom ioctls in favour of a standardised
way of doing it, but I'm not entirely sure how that should look.

That is really a minor detail but an important one so I'd like to see
what other feedback appears over the next few days (including some
weekdays).
 
> >>We could also the agree how that maps onto the extra gpio lines used with
> >>SIM card readers and the like so we can standardise that.
> 
> I'm open to suggestions on how to properly get this implemented, so if there is some more feedback you can give to point me in the right direction I'd be glad to consider it and resubmit.

For what sort of things are the GPIO lines generally used by customers ?

Alan



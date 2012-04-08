Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2DHRKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:10:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38663 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2DHRKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:10:21 -0400
Date: Sun, 8 Apr 2012 18:12:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120408181227.5d9430d9@pyramind.ukuu.org.uk>
In-Reply-To: <CAB=NE6X1NFLn6UfPHyNP9_uFTCdYUbtoTP0ds+0YT3_oFCZTSQ@mail.gmail.com>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
	<CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
	<CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
	<20120407024941.GB11295@thunk.org>
	<CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
	<20120407211512.GC11295@thunk.org>
	<CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
	<20120408155709.1c817f1f@pyramind.ukuu.org.uk>
	<CAB=NE6X1NFLn6UfPHyNP9_uFTCdYUbtoTP0ds+0YT3_oFCZTSQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dual licensing avoids some confusions, it also removes the worry about
> > possible unanticipated incompatibility. Right now if a court somewhere
> > says "Hey you know what - BSD and GPL are not compatible because XYZ" the
> > fact it is dual licensed avoids problems.
> 
> Interesting, I had not considered that case, is this really likely to
> happen now, I mean at least with the list of licenses listed as
> GPL-Compatible on the FSF site?

I would be very surprised - but why chance it ?

> in perspective to what extent do we want to remain speculative over
> the list the FSF provides on GPL-Compatibility for the Linux kernel?
> Are there, say, at least a few GPL-Compatible licenses which we are
> comfortable with in assuming GPL-Compatibility moving forward?

IMHO it's up to whoever wants another tag badly enough to submit a change
for it. Consider it optimising the problem by delayed evaluation.

Alan

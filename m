Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2DHOz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 10:55:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36467 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2DHOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 10:55:27 -0400
Date: Sun, 8 Apr 2012 15:57:09 +0100
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
Message-ID: <20120408155709.1c817f1f@pyramind.ukuu.org.uk>
In-Reply-To: <CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
	<CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
	<CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
	<20120407024941.GB11295@thunk.org>
	<CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
	<20120407211512.GC11295@thunk.org>
	<CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From the work with SFLC on ath5k a while ago we learned that dual
> licensing BSD/GPL is legally equivalent to licensing under the BSD
> license, dual licensing should be used when licensing a project / file
> under incompatible licenses. Dual licensing BSD/GPL can also confuse

Dual licensing avoids some confusions, it also removes the worry about
possible unanticipated incompatibility. Right now if a court somewhere
says "Hey you know what - BSD and GPL are not compatible because XYZ" the
fact it is dual licensed avoids problems.

> Well, I am arguing that "Dual BSD/GPL" is a stupid practice that has
> plagued the community and only has brought confusion. Its not needed
> and if one wants to share with the BSD community one should simply use
> the BSD license.

Which then creates the risk question. This *has* happened before although
not with a court. Long ago the FSF used to maintain the fiction that
advertising clause BSD was GPL compatible. When the lawyers looked at it
in detail they decided this was not the case and also came up with some
fun abuses to demonstrate the point.

> license. This is just for a file though.. but are we to keep extending
> this list for every new module license that is GPL-Compatible? That
> seems rather cumbersome.

It only really matters if you are trying to be clear about dual use code
- for example some of the wireless code shared with BSD and the DRI code
where it's intentionally available in both universes. At the time some
folks wanted it to be clear their code was dual licensed and didn't want
to tag it "GPLv2". That may well in truth be more about politics than law
but it's hardly unreasonable to respect authors requests when they can
easily be handled.

> As for run time... I *personally* actually believe all Linux kernel
> modules are GPL at runtime :D I'm not the one who argues that

So just mark your modules "GPLv2"

Feel free to change all those you are the sole owner for, but for
anything else go via the legal team of the relevant company and/or get
the owner to provide the change with appropriate sign off.

Alan

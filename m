Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2DNGCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:02:23 -0400
Received: from 1wt.eu ([62.212.114.60]:65137 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2DNGCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:02:21 -0400
Date: Sat, 14 Apr 2012 08:01:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
Message-ID: <20120414060158.GD19802@1wt.eu>
References: <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413190819.9469.qmail@stuge.se> <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
> No, I don't want the latest fixes, I want the latest *stable* kernel.

You have it, it's 3.3.2.

> v3.3 is stable, v3.4-rcx are not.

v3.3 *aims to be stable*. That's the big difference. A kernel starts
unstable and converges to something more stable over the time. 2.4 was
still experiencing minor issues that we didn't have in 2.6 when I did
the last release. There were even some security issues we decided not
to fix and to document instead. Still for its users it was considered
much more stable than 2.6 or 3.x.

> v3.4 would take months to cook,
> there will be several release candidates, and it won't be released
> until the known issues decrease to a reasonable level.
> 
> v3.3.x on the other hand are *not* stable.

Nobody said they *are* stable as per the definition of this word.
"stable" is the name of the branch which defines the longterm goal
which is achieved as releases are issued. It's the same with longterm
kernels. They try to maintain even less bugs and try to to introduce
new ones, eventhough this happens from time to time, development is
not an exact science.

> They contain patches
> backported from v3.4, but nobody guarantees they will work. There was
> no v3.3.1-rc1,

Few people test rc, and not all bugs or regressions can be detected by
just a build and a boot.

> so the first time the patches compromising v3.3.1 were
> generally tested together is in v3.3.1, at which point if somebody
> finds issues, it's too late; bad patches are *not* going to be removed
> in v3.3.2.

They would have been if the issue was specific to the backport, which it
was not.

> Once a tag is made, all the patches in it are dependent on
> the pace of the development of mainline (v3.4-rcx), which is
> definitely not stable, specially in the first release candidates.
> 
> IOW, the "stable" branch tries to be stable up to a point, then, it
> becomes a testing ground for mainline, and a tracking device for
> certain mainline issues.

No it's the opposite, it tries to be stable past one point. It's well
known that first stable releases still have a number of bugs, and it's
the reason why Greg takes time to maintain multiple branches in parallel.
Please stop playing the fool, everybody understands this and you make it
appear like bugs are put in stable on purpose, your reasoning really does
not make sense.

Please fork the kernel and maintain your own "morestable" branch, it will
be useful, really, because it will mean that whatever you have in your
branch that is not in stable has to be fixed in mainline, so it will hold
the information Linus wants not to lose. This is a lot of work but you'll
get it done without asking anyone else to do it. I'm not kidding, I'd
probably use it if it's maintained long enough.

Willy


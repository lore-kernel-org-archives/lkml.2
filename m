Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0KGAUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 20:20:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:43974 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0KGAUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:20:24 -0400
Date: Sat, 6 Nov 2010 17:20:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Ted Ts'o" <tytso@mit.edu>
cc: Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
In-Reply-To: <20101107000348.GF2935@thunk.org>
Message-ID: <alpine.DEB.2.00.1011061713310.29342@asgard.lang.hm>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <20101106192259.GB2935@thunk.org> <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
 <20101106234029.GC2935@thunk.org> <alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm> <20101107000348.GF2935@thunk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010, Ted Ts'o wrote:

> On Sat, Nov 06, 2010 at 04:52:26PM -0700, david@lang.hm wrote:
>> also, none of these other patches resulted in device drivers
>> developed for a distro being incompatible with mainline.
>
> What, people can't delete a couple of single lines of code before
> submitting the device driver upstream to mainline?  Here's the world's
> tiniest violin playing, "my heart bleeds for you"....

the problem is that wouldn't be the version that would be maintained.

>> I think that the concerns from technical folks (as opposed to
>> journalists/bloggers) would go down drastically if there was some
>> acceptable way for the incompatible bits (like wakelocks) could be
>> stubbed out so that the rest of the things could be moved easily.
>
> That was offerred as an interim/temporary solution, but no one seems
> willing to commit that those stubs exist permanently.  At best, for
> another 6-9 months before they would be yanked out again, which would
> spur more fodder for the journalists/bloggers.
>
> Personally, I would think that temporary stubs would be really bad,
> raw deal for the Android team.  It would force them through another
> set of hundreds of manhours worth of discussions (my folder with these
> discussions is currently 10 megabytes of e-mail; given that there seem
> to be irroncilable differences with respect to philosophy, and perhaps
> outright commercial incentives that the Android approach not go in by
> some of the participants, I have very little personal hope that more
> talks would go anywhere), and then after 6-9 months, it would be, "no
> forward progress", followed by the stubs getting yanked from the
> kernel, followed by more rounds of misinformed articles written by the
> tech tabloid community.
>
> Why would this be a good deal for anybody?

Doing temporary stubs would be really bad for all the reasons you state. 
That's why I said that the stubs would have to be acceptable to everyone. 
they will be in there for a long time, and would probably end up being 
used in other drivers (ones that are in mainline now) so that they could 
used by android.

unfortunantly this is not something that has been acceptable upstream. I 
understand the reluctance for this (and the disaster we would have if 
things like this happened frequently), I just wonder if being able to get 
the drivers for phones in mainline may be worth the maintinance overhead 
of allowing these stubs permanently in mainline

David Lang

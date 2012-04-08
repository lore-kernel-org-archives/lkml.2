Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2DHQHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 12:07:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50604 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2DHQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 12:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120408155709.1c817f1f@pyramind.ukuu.org.uk>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
 <20120407024941.GB11295@thunk.org> <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
 <20120407211512.GC11295@thunk.org> <CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
 <20120408155709.1c817f1f@pyramind.ukuu.org.uk>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Sun, 8 Apr 2012 09:06:42 -0700
X-Google-Sender-Auth: 21hqETxXceceRFzkCwxYQfbcI9E
Message-ID: <CAB=NE6X1NFLn6UfPHyNP9_uFTCdYUbtoTP0ds+0YT3_oFCZTSQ@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 7:57 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >From the work with SFLC on ath5k a while ago we learned that dual
>> licensing BSD/GPL is legally equivalent to licensing under the BSD
>> license, dual licensing should be used when licensing a project / file
>> under incompatible licenses. Dual licensing BSD/GPL can also confuse
>
> Dual licensing avoids some confusions, it also removes the worry about
> possible unanticipated incompatibility. Right now if a court somewhere
> says "Hey you know what - BSD and GPL are not compatible because XYZ" the
> fact it is dual licensed avoids problems.

Interesting, I had not considered that case, is this really likely to
happen now, I mean at least with the list of licenses listed as
GPL-Compatible on the FSF site?

>> Well, I am arguing that "Dual BSD/GPL" is a stupid practice that has
>> plagued the community and only has brought confusion. Its not needed
>> and if one wants to share with the BSD community one should simply use
>> the BSD license.
>
> Which then creates the risk question. This *has* happened before although
> not with a court. Long ago the FSF used to maintain the fiction that
> advertising clause BSD was GPL compatible. When the lawyers looked at it
> in detail they decided this was not the case and also came up with some
> fun abuses to demonstrate the point.

Thanks for the background, this provides a good amount of historical
background as to *why* people started doing Dual BSD/GPL and it makes
perfect sense. I do wonder if after all the review and history if we
could end up in a situation where certain listed GPL-Compatible
licenses could be found as incompatible...

With historical context I now get why Dual BSD/GPL was used but even
in perspective to what extent do we want to remain speculative over
the list the FSF provides on GPL-Compatibility for the Linux kernel?
Are there, say, at least a few GPL-Compatible licenses which we are
comfortable with in assuming GPL-Compatibility moving forward?

>> license. This is just for a file though.. but are we to keep extending
>> this list for every new module license that is GPL-Compatible? That
>> seems rather cumbersome.
>
> It only really matters if you are trying to be clear about dual use code
> - for example some of the wireless code shared with BSD and the DRI code
> where it's intentionally available in both universes. At the time some
> folks wanted it to be clear their code was dual licensed and didn't want
> to tag it "GPLv2". That may well in truth be more about politics than law
> but it's hardly unreasonable to respect authors requests when they can
> easily be handled.
>
>> As for run time... I *personally* actually believe all Linux kernel
>> modules are GPL at runtime :D I'm not the one who argues that
>
> So just mark your modules "GPLv2"

It is what I also concluded on another thread with Ted.

> Feel free to change all those you are the sole owner for, but for
> anything else go via the legal team of the relevant company and/or get
> the owner to provide the change with appropriate sign off.

This makes sense given the historical context under which the Dual
tags were introduced, even though today they may seem unnecessary.

  Luis

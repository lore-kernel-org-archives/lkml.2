Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0ISTVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 15:21:01 -0400
Received: from snt0-omc3-s3.snt0.hotmail.com ([65.55.90.142]:8858 "EHLO
	snt0-omc3-s3.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab0ISTVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 15:21:00 -0400
Message-ID: <SNT125-W305F365835060339BD4008C37D0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <torvalds@linux-foundation.org>, <peterz@infradead.org>
CC: <cyeoh@au1.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>
Subject: RE: [RFC][PATCH] Cross Memory Attach
Date: Sun, 19 Sep 2010 12:20:59 -0700
Importance: Normal
In-Reply-To: <AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
 <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop>
 <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop>
 <AANLkTikquj_2DE4UhTFAoDxL+,<AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Sep 2010 19:20:59.0901 (UTC) FILETIME=[CAC81AD0:01CB582F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Adding Russell King of ARM Linux to CC list)

----------------------------------------
> From: torvalds@linux-foundation.org
> Date: Thu, 16 Sep 2010 10:54:29 -0700
> Subject: Re: [RFC][PATCH] Cross Memory Attach
> To: peterz@infradead.org
> CC: cyeoh@au1.ibm.com; linux-kernel@vger.kernel.org
>
> On Thu, Sep 16, 2010 at 10:47 AM, Peter Zijlstra  wrote:
> > On Thu, 2010-09-16 at 10:34 -0700, Linus Torvalds wrote:
> >>
> >> Of course, these days I would seriously suggest against trying to
> >> optimize the kmap() case. It only matters on crap hardware these days.
> >> Anybody running HIGHMEM in 2010 and thinks that it makes sense
> >> deserves the pain the get. We should not complicate the kernel further
> >> for it, and sane architectures will have a no-op kmap().
> >
> > OK, fully agreed. Someone ought to tell ARM though :-)
>
> You know what? I don't care. If the fact that ARM is messing up means
> that they will never be able to do well in the micro-server space,
> that's _their_ problem.
>
> I fought HIGHMEM tooth and nail when it appeared originally. I lost,
> because we really didn't have any choice. But there is no way I'm
> going to say "oh, HIGHMEM still makes sense in 2010 because the ARM
> guys are now making all the same mistakes Intel did in 1992". Because
> these days we _do_ have a choice.
>
> And all the rumors are that there will be a 64-bit ARM too. So their
> PAE mess will be out before, but nobody sane should really consider it
> a primary issue. It will work, but it will work suboptimally. That's
> what you get when you have bad hardware design.
>
> Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
>
 		 	   		  
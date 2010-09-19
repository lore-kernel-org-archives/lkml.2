Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0ISVsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 17:48:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50778 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0ISVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 17:48:32 -0400
Date: Sun, 19 Sep 2010 22:48:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, cyeoh@au1.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100919214802.GA22579@n2100.arm.linux.org.uk>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com> <1284654451.2275.579.camel@laptop> <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com> <1284657194.2275.585.camel@laptop> <AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com> <SNT125-W305F365835060339BD4008C37D0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SNT125-W305F365835060339BD4008C37D0@phx.gbl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 12:20:59PM -0700, Yuhong Bao wrote:
> 
> (Adding Russell King of ARM Linux to CC list)

I'm not sure why you're repeatedly sending me this email (this is the
second in less than 24 hours.)

In any case, it's not like I can influence the direction ARM Ltd take
their architecture - I only hear about stuff after the decisions have
been taken and the direction set.  (Sometimes I hear about stuff just
before the public announcement.)

So, if you think I can do anything to stop the move towards LPAS
(large physical address space) and tell ARM to go to 64-bit directly,
you're sadly mistaken.

> ----------------------------------------
> > From: torvalds@linux-foundation.org
> > Date: Thu, 16 Sep 2010 10:54:29 -0700
> > Subject: Re: [RFC][PATCH] Cross Memory Attach
> > To: peterz@infradead.org
> > CC: cyeoh@au1.ibm.com; linux-kernel@vger.kernel.org
> >
> > On Thu, Sep 16, 2010 at 10:47 AM, Peter Zijlstra  wrote:
> > > On Thu, 2010-09-16 at 10:34 -0700, Linus Torvalds wrote:
> > >>
> > >> Of course, these days I would seriously suggest against trying to
> > >> optimize the kmap() case. It only matters on crap hardware these days.
> > >> Anybody running HIGHMEM in 2010 and thinks that it makes sense
> > >> deserves the pain the get. We should not complicate the kernel further
> > >> for it, and sane architectures will have a no-op kmap().
> > >
> > > OK, fully agreed. Someone ought to tell ARM though :-)
> >
> > You know what? I don't care. If the fact that ARM is messing up means
> > that they will never be able to do well in the micro-server space,
> > that's _their_ problem.
> >
> > I fought HIGHMEM tooth and nail when it appeared originally. I lost,
> > because we really didn't have any choice. But there is no way I'm
> > going to say "oh, HIGHMEM still makes sense in 2010 because the ARM
> > guys are now making all the same mistakes Intel did in 1992". Because
> > these days we _do_ have a choice.
> >
> > And all the rumors are that there will be a 64-bit ARM too. So their
> > PAE mess will be out before, but nobody sane should really consider it
> > a primary issue. It will work, but it will work suboptimally. That's
> > what you get when you have bad hardware design.
> >
> > Linus
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at http://www.tux.org/lkml/
> >
> >
>  		 	   		  

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2IWAPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 20:15:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:22967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab2IWAP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 20:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,469,1344236400"; 
   d="scan'208";a="225350900"
Date: Sun, 23 Sep 2012 08:15:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Linux 3.6-rc6
Message-ID: <20120923001522.GA8383@localhost>
References: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
 <20120922005905.GA8335@digium.com>
 <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 11:57:23AM -0700, Linus Torvalds wrote:
> On Fri, Sep 21, 2012 at 5:59 PM, Shaun Ruffell <sruffell@digium.com> wrote:
> >
> > I posted patches [1,2,3] that resolve the issue for me. Shaohui Xie
> > also hit the issue and posted a slightly different patch [4]. The
> > patches are currently waiting for Mauro, who I understand is
> > catching up since returning from San Diego, to check them out.
> >
> > [1] http://marc.info/?l=linux-kernel&m=134764595921752&w=2
> > [2] http://marc.info/?l=linux-kernel&m=134764594721747&w=2
> > [3] http://marc.info/?l=linux-kernel&m=134764597921761&w=2
> > [4] http://marc.info/?l=linux-kernel&m=134753579818528&w=2
> 
> That first patch needs a sign-off from you, since you are passing on
> somebody elses patch.
> 
> Looking at that patch, the patch seems to be a memory leak (?) leaking
> the "channels" allocation, along with fixing an odd and incorrect

Yes.

> kfree (and access) of mci->csrows[i]. If that is correct, please write

Right.

> a proper changelog. The current changelog for that thing is totally
> pointless, and doesn't actually explain what the patch *does*.
 
Sorry I'll send the fix with more complete changelog in a standalone
patch for review.

> I'd also like some ack's from people, and I'd love to know which
> commit introduced the problem(s). If this problem is new to 3.6, I
> want to know what caused it, and if it is *not* new, then the thing
> needs to be marked for stable. Please?

It's a new bug to 3.6.

Thanks,
Fengguang

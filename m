Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1HIRl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:41:26 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:39839 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1HIRlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:41:25 -0400
Date: Tue, 9 Aug 2011 21:40:01 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Luke-Jr <luke@dashjr.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110809174001.GA23408@tugrik.mns.mnsspb.ru>
References: <013811$4lfs6@fmsmga002.fm.intel.com> <201108091809.58425.anarsoul@gmail.com> <20110809153446.GA22077@tugrik.mns.mnsspb.ru> <201108091903.00071.anarsoul@gmail.com> <20110809163206.GA3410@tugrik.mns.mnsspb.ru> <CADU53JVXiX2v+5N-VP8mz6vnxF60BYYXKV_PZQdd_U+qM5Gd6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADU53JVXiX2v+5N-VP8mz6vnxF60BYYXKV_PZQdd_U+qM5Gd6A@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 09:56:01AM -0700, Ray Lee wrote:
> On Tue, Aug 9, 2011 at 9:32 AM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > Quite frankly, I don't understand intel-gfx developers attitude: why is
> > it me, just random user who is nitpicking here? Why there is no
> > interest/will to analyze now obviously buggy/duplicate code and fix it?
> 
> Because they don't have an infinite amount of manpower. Actual bugs
> hitting actual users take precedence over 'cleanups' which always have
> a chance of causing regressions, as you're well aware. Code churn for
> the sake of abstract prettiness is discouraged, as it has a potential
> cost for little potential gain.
> 
> If you like, submit a patch. You may now be more up-to-date on those
> particular code paths than most of the intel-gfx developers.

Ray, I'd agree with you if the topic was about cleanups.

But here I was talking about copy-pasty commit which introduced
regressions and bugs, and if now it's a user dilemma to either "clean up"
it after developers himself, or accept that something is broken because
developers lack manpower and so plug things in a hurry increasing
entropy, I'd like to remind a good rule, at least to me one more time,
not to break things in the first place.

I'm not talking about cleanup here. I'm talking about original commit
which introduced problems, and that there is no need to clean it up, but
better revert and redo properly to avoid subsequent code churn in lots
of fixes.


Sorry, I won't submit a patch. If there is a need to find/fix/cleanup
obvious things after company's developers, I have better things to do,
and a todo item to re-evaluate hardware for my next project.


Thanks,
Kirill

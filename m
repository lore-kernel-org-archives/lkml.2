Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1HJIiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:38:22 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:51688 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab1HJIiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:38:21 -0400
Date: Wed, 10 Aug 2011 12:36:50 +0400
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
Message-ID: <20110810083650.GB3187@tugrik.mns.mnsspb.ru>
References: <013811$4lfs6@fmsmga002.fm.intel.com> <201108091809.58425.anarsoul@gmail.com> <20110809153446.GA22077@tugrik.mns.mnsspb.ru> <201108091903.00071.anarsoul@gmail.com> <20110809163206.GA3410@tugrik.mns.mnsspb.ru> <CADU53JVXiX2v+5N-VP8mz6vnxF60BYYXKV_PZQdd_U+qM5Gd6A@mail.gmail.com> <20110809174001.GA23408@tugrik.mns.mnsspb.ru> <CADU53JW0-HaLZcSQ49G8bj2aHBJCL8Ub8MeGYBOd_wZmoDc4Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADU53JW0-HaLZcSQ49G8bj2aHBJCL8Ub8MeGYBOd_wZmoDc4Tg@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 10:43:08AM -0700, Ray Lee wrote:
> On Tue, Aug 9, 2011 at 10:40 AM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> >> If you like, submit a patch. You may now be more up-to-date on those
> >> particular code paths than most of the intel-gfx developers.
> >
> > Ray, I'd agree with you if the topic was about cleanups.
> 
> At this point it is about cleanups unless Keith's patch upthread does
> not work for you. Does it or not?

I've already wrote two weeks ago it does, but if this needs to be
restated one more time here it is: Keith's patch fixes the problem in a
sense that X now starts and seemingly works (thanks), but several issues
remain to be there imho. I've got the message, if it's ok for intel-gfx
to leave them as is - it's ok for me.


Peace,
Kirill

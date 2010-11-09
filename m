Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0KIXJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:09:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab0KIXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:09:18 -0500
Date: Tue, 9 Nov 2010 15:09:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
Message-Id: <20101109150906.af2804ac.akpm@linux-foundation.org>
In-Reply-To: <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
References: <20101025235804.GA11760@outflux.net>
	<AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
	<20101109205008.GU5876@outflux.net>
	<AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 14:46:30 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Nov 9, 2010 at 12:50 PM, Kees Cook <kees.cook@canonical.com> wrote:
> >
> > No one has committed it. I don't know why; I've sent it a few times now.
> 
> You seem to have sent it just to lkml. At least in this case the patch
> itself was not sent to me (only the subsequent replies were), and the
> choice of recipients was fairly odd apart from Andrew (who probably
> _is_ the right person).

It's in my backlog queue.  Waaaay back.  

The -rc1 merging and kermel summit put me way behind (again) and when
I'm way behind, I start to work in reverse order (mainly to avoid
looking at older versions of patches).  And when I'm working in
time-reverse order, things which were sent a long time ago get delayed
even more.

The good news is that the longer I take to merge something, the less
likely it is that I'll actually merge it ;) Either it got shot down or
a new version came out or someone else merged it.


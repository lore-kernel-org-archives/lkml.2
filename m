Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1JYJvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:51:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49392 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JYJvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:51:05 -0400
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <CA+55aFzUtu5jVt6XcP+cqLWSK1u+zbuJuWCJU0OhW2XVavv3VA@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
	 <CA+55aFzUtu5jVt6XcP+cqLWSK1u+zbuJuWCJU0OhW2XVavv3VA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 02:51:02 -0700
Message-ID: <1319536262.18871.14.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 11:44 +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:29 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. This is not what I get. It might be a git version issue or diff
> > algorithm one - although that's actually pretty unusual. Do you do
> > something odd/special?
> 
> Another question: you picked a very particular and odd place to start
> development. It's commit 65112dccf8a ("Merge
> git://git.samba.org/sfrench/cifs-2.6") which just *seems* to be some
> "random Linux tree kernel of the day". I'm not seeing why you picked
> that one.
> 
> This is not a deal-breaker, and *please* don't use this as an argument
> for rebasing (quite the opposite), but it's basically a note to ask
> you to just pick a better starting point next time. It's usually much
> better to start from an actual release (preferably a *real* release,
> like 3.0) than from a "random daily tree". Of course, using an -rc1
> release is usually a really bad idea also, but in the rough timeframe
> we're talking about (October 10 - two weeks ago - that's apparently
> when you started worrying about this next merge window) you could have
> at least picked something like -rc9 as the base.
> 
> So basically, I'm asking that people not rebase, but also spend a bit
> of time thinking about "where should I start development".
> 

Point understood.   I'll make sure to pick a tagged -rc release for the
target-pending.git base next time.

Thank you,

--nab



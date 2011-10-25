Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1JYJoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:44:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52178 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1JYJoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org> <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 11:44:20 +0200
X-Google-Sender-Auth: a8GkhuXW58sfefnft9hT7vSNixU
Message-ID: <CA+55aFzUtu5jVt6XcP+cqLWSK1u+zbuJuWCJU0OhW2XVavv3VA@mail.gmail.com>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. This is not what I get. It might be a git version issue or diff
> algorithm one - although that's actually pretty unusual. Do you do
> something odd/special?

Another question: you picked a very particular and odd place to start
development. It's commit 65112dccf8a ("Merge
git://git.samba.org/sfrench/cifs-2.6") which just *seems* to be some
"random Linux tree kernel of the day". I'm not seeing why you picked
that one.

This is not a deal-breaker, and *please* don't use this as an argument
for rebasing (quite the opposite), but it's basically a note to ask
you to just pick a better starting point next time. It's usually much
better to start from an actual release (preferably a *real* release,
like 3.0) than from a "random daily tree". Of course, using an -rc1
release is usually a really bad idea also, but in the rough timeframe
we're talking about (October 10 - two weeks ago - that's apparently
when you started worrying about this next merge window) you could have
at least picked something like -rc9 as the base.

So basically, I'm asking that people not rebase, but also spend a bit
of time thinking about "where should I start development".

                      Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2GXQsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:48:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54336 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2GXQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:48:14 -0400
MIME-Version: 1.0
In-Reply-To: <1343109280-22653-1-git-send-email-lliubbo@gmail.com>
References: <1343109280-22653-1-git-send-email-lliubbo@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 09:47:52 -0700
X-Google-Sender-Auth: X3ymunVkB6AoqSOxXO1T7BnnQtc
Message-ID: <CA+55aFx4bytJFzJTbCbp-YTEfuGo9di3oyBwY87BRRXszfK5Rg@mail.gmail.com>
Subject: Re: [GIT PULL v2] Blackfin changes for 3.6-rc1
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        vapier@gentoo.org, sonic.zhang@analog.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 10:54 PM, Bob Liu <lliubbo@gmail.com> wrote:
>
> This is the new pull request about blackfin changes for 3.6-rc1.
> I've rebased my tree to 3.5.

So I pulled it, but next time I'd really like to not see so much
recent rebasing.

So preferably it would be something that has been stable for at least
a week, and tested in next. If you really need to use some kind of
rebasing model, try to calm it down *before* the merge window starts,
so that you can have a tested tree ready without rebasing it in the
last few days.

The release schedule is generally predictable enough that you can (for
example) decide to pick a fairly stable -rc version (say -rc5 or -rc6,
by which time the kernel should be pretty reliable), and use that as
your base point, and keep it in -next *without* rebasing at all (just
possibly add new patches at the end).

Generally, the less you rebase, the better. Yes, sometimes it's worth
it as a way to clean up the history especially if you need some
changes that come from elsewhere, or if you want to fix a bug in a
commit that you haven't asked me to pull yet. But if you can get to a
workflow with minimal rebasing, it really helps people who want to
work with you, so that they can rely on your tree not changing from
under them.

Now, I assume that blackfin just doesn't have enough developers or big
changes for this to be a big deal, but it's a good habit to aim for
regardless.

                   Linus

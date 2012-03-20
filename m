Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030335Ab2CTASn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:18:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925Ab2CTASm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120319152317.GA3932@gmail.com>
References: <20120319152317.GA3932@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Mar 2012 17:18:21 -0700
X-Google-Sender-Auth: jksHWEK-QVjpekECrUsdOxOxrdw
Message-ID: <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.4
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 8:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest core-rcu-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

So Ingo, Paul - I'd really have liked to have some high-level
user-readable explanation of the changes that I could have put in the
merge message.

This is especially true for something like RCU, which (a) seems to be
continually growing and (b) has had cases of "oops, now it stopped
working" or "uhhuh, new rules due to new rcu implementations
interacting differently with spinlocks" etc.

So when the diffstat summary looks like this:

  29 files changed, 2965 insertions(+), 642 deletions(-)

with basically 2000+ new lines (yes, many of them in Documebntation,
happily, but rcutree grew noticeably too), it really would have been
nice to have some blurb about what the heck actually happened, ok?

I'm starting to get explanations in signed tags or in the "please
pull" messages from a fairly large number of maintainers now, and the
pulls from Ingo are beginning to look sad and unexplained in contrast.

                     Linus

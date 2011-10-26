Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1JZCpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 22:45:22 -0400
Received: from ozlabs.org ([203.10.76.45]:32829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab1JZCpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 22:45:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PULL] module and param
In-Reply-To: <CA+55aFyU=GxX+=b=Q2OP3BJNQuth7GWuAv5Zd63n209EJ0VOyw@mail.gmail.com>
References: <87mxcppwg0.fsf@rustcorp.com.au> <CA+55aFyU=GxX+=b=Q2OP3BJNQuth7GWuAv5Zd63n209EJ0VOyw@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Oct 2011 13:13:58 +1030
Message-ID: <878vo8pj4h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 09:33:16 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> [ Cut-and-paste reply: mentally just "sed s/9p/module/g" ]
> 
> So for the merge window, I *really* want the development trees I pull
> from explicitly verified some way.
>
> Putting a signed tag on there somewhere that actually signs the top
> commit *and* mentions the repository and branch it is on (ie github)
> is not wonderfully convenient, but it's at least relatively
> straightforward (do I have a gpg key I can trust?).

I'm not sure if this paranoia is disproportionate or overdue.  Hope I
did it right (D1ADB8F1, signed by some other OzLabs folks).

Personally I would have thought that asking people to patch a gpg
fingerprint into MAINTAINERS is more kernely than web of trust.  I'll
notice if someone else tries to patch their own in there.

Cheers,
Rusty.

To git@github.com:rustyrussell/linux.git
 + 694136c...b1e4d20 master -> master (forced update)
 * [new tag]         rusty@rustcorp.com.au-v3.1-2-gb1e4d20 -> rusty@rustcorp.com.au-v3.1-2-gb1e4d20
The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://github.com/rustyrussell/linux.git master

Jiri Kosina (1):
      kmod: prevent kmod_loop_msg overflow in __request_module()

Michal Schmidt (1):
      params: make dashes and underscores in parameter names truly equal

 include/linux/moduleparam.h |   20 ++++++++++++++++++++
 init/main.c                 |    4 ++--
 kernel/kmod.c               |    4 +++-
 kernel/params.c             |   21 ++++++++++++++-------
 4 files changed, 39 insertions(+), 10 deletions(-)

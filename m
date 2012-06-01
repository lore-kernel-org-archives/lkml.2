Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab2FART5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:19:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2FARTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwk8oYx8EKWdT=5cMTLK7RDz8GQdGmHk2KXwcCq+Bb8PA@mail.gmail.com>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com> <CA+55aFwk8oYx8EKWdT=5cMTLK7RDz8GQdGmHk2KXwcCq+Bb8PA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 10:19:33 -0700
X-Google-Sender-Auth: vHBs6fw-Cray9fN5zs9-hx31KIA
Message-ID: <CA+55aFwwfMTN=WGQGmFO7DYeBUOGA7V4_6XueQS4JAzeykwn3Q@mail.gmail.com>
Subject: Re: GIT PULL] ext4 updates for 3.5
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Is there perhaps a tag I should pull instead?

Never mind, I see it. It's 'ext4_for_linus'.

So here's the odd 'git' trick of the day.  Do

   git ls-remote
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 | less -S

to see all the branches and tags. In there, we see the branch you
asked me to pull:

  5e44f8c374.. refs/heads/dev

and then we can see if perhaps any of the tags have that same commit
when peeled. So search for 5e44f8c374, and sure enough:

  ..
  4e4d525149..  refs/tags/ext4_for_linus
  5e44f8c374..  refs/tags/ext4_for_linus^{}
  ..

so that 'ext4_for_linus' tag (which obviously has a different SHA1
than the commit it points to) points to the same commit (the "^{}" is
just the git SHA1 expression for "commit pointed to by object").

So pulling 'ext4_for_linus' instead of 'dev' will get me the same
commits you asked me to pull, with the added tag information that your
pull request containes.

Now I just wonder why your pull request said 'dev' at all.

            Linus

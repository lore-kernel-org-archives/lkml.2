Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1JZOFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:05:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1JZOFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:05:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwHw=xSdk7VtHCiVKzfzvGS=d8hXwwfaPEcU=P6PDarsA@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
	<CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
	<CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
	<CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
	<FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
	<CA+55aFwHw=xSdk7VtHCiVKzfzvGS=d8hXwwfaPEcU=P6PDarsA@mail.gmail.com>
Date: Wed, 26 Oct 2011 16:05:13 +0200
X-Google-Sender-Auth: -VZHzHJs6b5aro_xBxbIPUUYcRo
Message-ID: <CAMuHMdU71jN=SWUU7O-Cq7ZtCi9r+3fhih72gBRPscagkGipjQ@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 14:58, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 26, 2011 at 2:48 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> What's the preferred maintainer workflow?  I had been fetching and then rebasing, which seemed to keep my shortlog clean of merge commits and the outstanding patches towards the top.  Should I just be pulling from upstream and not caring about the merge commits?
>
> Hell no.
>
> Why do you pull from upstream? What does that add to *your*
> development? Don't do it. Pick a place to start, and just develop
> things. Ask me to pull.
>
> No merge commits, no rebases, no nothing. JUST ACTUAL WORK. It also
> keeps the history clean, and means that what people test (in
> linux-next _and_ in your own internal testing) is actually what you
> ask me to pull, rather than something else.

That works if what you do is "small" and "fast".

"small":
  - There are no conflicts with anyone else who is e.g. restructuring
part of the tree,
  - You do not want to early submit parts that should go in through a different
    maintainer as soon as they're ready (and thus they disappear from
your patchset
    when you rebase),

"fast":
  - You started working on it after the last merge window, and not 3
releases ago.

If the above are not true, it's a hell of work to keep track of
everything without
rebasing. Not to mention that the reviewers don't like seeing patches that apply
to obsolete trees.

And of course I don't want to bother you with fixing the merge
conflicts that happen
when I would ask to pull e.g. the m68k genirq conversion based on the
state of your
tree when I started working on it ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

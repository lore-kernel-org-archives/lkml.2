Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab2AIWz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:55:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63181 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab2AIWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:55:56 -0500
MIME-Version: 1.0
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 14:55:34 -0800
X-Google-Sender-Auth: RyhRlzE1nkz16YzG58-KY3rr7HM
Message-ID: <CA+55aFzV5yRB9toW2efXWRKmYzKKRnLHd5FnF=As0vBgFb=OsQ@mail.gmail.com>
Subject: Re: [GIT PULL 00/11] arm-soc changes
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 2:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> For each branch "next/foo", there is also a signed tag "foo" on the
> arm-soc git. Please pull whichever of these you prefer.

So I pulled the tags, because not only do I then get the signature,
but the merge message will automatically also end up containing your
notes that you put in the tags. Which is a nice feature worth pointing
out to people: when you send me pull-requests, you can add commentary
that actually gets saved in the tag.

So to give an example from Arnd's series, look at commit e8cbce976050
in the current -git tree (just pushed out, since I did the merges just
moments ago):

  [torvalds@i5 linux]$ git show e8cbce976050
  commit e8cbce976050a9f874a8b07012ddeb9b9eb59603
  Merge: b3c37522928b 27fdb577435e
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Mon Jan 9 14:40:48 2012 -0800

    Merge tag 'timer' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

    timer changes for msm

    A very simple series. We used to have more churn in the timer
    area, so this is kept separate. Will probably put this into the
    drivers series next time.

    * tag 'timer' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc:
      msm: timer: Use clockevents_config_and_register()
      msm: timer: Setup interrupt after registering clockevent
      msm: timer: Remove SoC specific #ifdefs
      msm: timer: Remove msm_clocks[] and simplify code
      msm: timer: Fix ONESHOT mode interrupts
      msm: timer: Use GPT for clockevents and DGT for clocksource
      msm: timer: Cleanup #includes and #defines
      msm: timer: Tighten #ifdef for local timer support

where those "timer changes for msm" and the comment about a simple
series were all from Arnd's tag.

Now, you don't *have* to do these kinds of descriptions, and I do end
up editing them if they look odd (eg Arnd saying "I" when the commit
then ends up being mine), but I wanted to point it out because some
submaintainers may end up enjoying the capability to add notes to the
merge to explain things better.

And Arnd, please do double-check that I didn't mess up any of the
(pretty trivial) merge conflicts..

                         Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1JZNEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:04:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60147 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab1JZNEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGQmK7PvdMaKu9ezPDmeHPaKMCSb5izK5p5tTatmLbptg@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
	<CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
	<CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
	<CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
	<FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
	<CAOJsxLGQmK7PvdMaKu9ezPDmeHPaKMCSb5izK5p5tTatmLbptg@mail.gmail.com>
Date: Wed, 26 Oct 2011 16:04:40 +0300
X-Google-Sender-Auth: U0POjBHN5Bc08onewQ16W6seR4s
Message-ID: <CAOJsxLEX=LRQK+zo1m1SmizwziOyU_qOcbJ+hYOBb4Un+3FCUg@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 4:00 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> I don't know if mine is the preferred workflow but what I usually do is:
>
>  1. Send a pull request to Linus in a separate throw-away branch
>      that's an exact copy of my "next" branch.
>
>  2. Wait until -rc1 is out and git reset my "next" branch to that.
>
>  3. Apply patches on top of the "next" branch. I never rebase or
>      do merges from Linus tree to the branch.
>
>  4. Once the merge window opens, goto 1.
>
> [ Actually, I sometimes have multiple "next" topic branches if there's a risk
>  that I need to back out some of the changes from linux-next in the middle
>   of the merge cycle. ]

And oh, I usually set up a local 'testing' branch when the merge
window opens merge latest release and my 'next' branch to it. It's
mostly a sanity check before I send a pull request to Linus to check
that everything still works. I never publish this branch nor make it
part of the pull request to Linus.

                        Pekka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab1JZNAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:00:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45162 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab1JZNAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
	<CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
	<CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
	<CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
	<FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
Date: Wed, 26 Oct 2011 16:00:13 +0300
X-Google-Sender-Auth: S_XEF21YaWZM_L4jdnbrD2TANbE
Message-ID: <CAOJsxLGQmK7PvdMaKu9ezPDmeHPaKMCSb5izK5p5tTatmLbptg@mail.gmail.com>
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

Hi Eric,

On Wed, Oct 26, 2011 at 3:48 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> What's the preferred maintainer workflow?  I had been fetching and then rebasing, which
> seemed to keep my shortlog clean of merge commits and the outstanding patches
> towards the top.  Should I just be pulling from upstream and not caring about the merge
> commits?

I don't know if mine is the preferred workflow but what I usually do is:

  1. Send a pull request to Linus in a separate throw-away branch
      that's an exact copy of my "next" branch.

  2. Wait until -rc1 is out and git reset my "next" branch to that.

  3. Apply patches on top of the "next" branch. I never rebase or
      do merges from Linus tree to the branch.

  4. Once the merge window opens, goto 1.

[ Actually, I sometimes have multiple "next" topic branches if there's a risk
  that I need to back out some of the changes from linux-next in the middle
   of the merge cycle. ]

                        Pekka

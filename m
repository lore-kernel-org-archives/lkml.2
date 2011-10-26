Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab1JZM6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:58:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60040 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab1JZM6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
 <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
 <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com> <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 14:58:15 +0200
X-Google-Sender-Auth: fcNFL3rXDCc7IB3vfqCqnYS5cHw
Message-ID: <CA+55aFwHw=xSdk7VtHCiVKzfzvGS=d8hXwwfaPEcU=P6PDarsA@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 2:48 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>
> What's the preferred maintainer workflow?  I had been fetching and then rebasing, which seemed to keep my shortlog clean of merge commits and the outstanding patches towards the top.  Should I just be pulling from upstream and not caring about the merge commits?

Hell no.

Why do you pull from upstream? What does that add to *your*
development? Don't do it. Pick a place to start, and just develop
things. Ask me to pull.

No merge commits, no rebases, no nothing. JUST ACTUAL WORK. It also
keeps the history clean, and means that what people test (in
linux-next _and_ in your own internal testing) is actually what you
ask me to pull, rather than something else.

> Also, as a point of clarification, if I do get my kernel.org tree back, should I continue to sign tags for pull-requests or was that just for external repos like github?

Just for external repos on sites that have no other verification.

We may want to do the whole git-level signing for everything
eventually, but only if/when git makes it easy to sign the pull
request (and verify it). Until then, the "make a separate signature"
is just a way to avoid the "I have no idea who you are" issue.

                     Linus

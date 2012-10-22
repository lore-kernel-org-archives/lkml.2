Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2JVWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:34:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab2JVWew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:34:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bryan Wu <cooloney@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Miles Lane <miles.lane@gmail.com>, akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
Date: Tue, 23 Oct 2012 00:38:44 +0200
Message-ID: <2097144.LhjfvZ65DK@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAK5ve-KDqi0HwE8upAmRmZUPcs=wgid_9QkQNksSGFUkWdEi+Q@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com> <CAK5ve-Lm6T0u08ZV+kw5+X_JUAoXksoPcxBo9FKAqQgdp6RRLA@mail.gmail.com> <CAK5ve-KDqi0HwE8upAmRmZUPcs=wgid_9QkQNksSGFUkWdEi+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 of October 2012 11:59:19 Bryan Wu wrote:
> Hiya,
> 
> Can I get some Acked or Tested-by from Rafael or Miles before I put it
> in my linux-leds tree?

Well, I just explained why the current code didn't work. :-)

Anyway, please feel free to add

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

to the patch (assuming that the performance impact is negligible).

Thanks,
Rafael


> On Thu, Oct 18, 2012 at 12:34 PM, Bryan Wu <cooloney@gmail.com> wrote:
> > On Thu, Oct 18, 2012 at 11:35 AM, Linus Walleij
> > <linus.walleij@linaro.org> wrote:
> >> On Thu, Oct 18, 2012 at 8:18 PM, Bryan Wu <cooloney@gmail.com> wrote:
> >>
> >>> Mutex lock is not safe in atomic context like the bug reported by
> >>> Miles Lane:
> >> (...)
> >>> This patch replace mutex lock with spin lock which is safe for this case.
> >>>
> >>> Reported-by: Miles Lane <miles.lane@gmail.com>
> >>> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>> Cc: Linus Walleij <linus.walleij@linaro.org>
> >>> Signed-off-by: Bryan Wu <cooloney@gmail.com>
> >>
> >> Looks correct to me:
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >>
> >
> > Thanks, Linus.
> >
> > Miles, could you please help to try this patch on your testing system?
> > I really appreciate it.
> >
> > -Bryan
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

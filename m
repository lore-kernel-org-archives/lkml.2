Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1APTW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:22:57 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15785 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1APTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:22:56 -0500
Date: Sun, 16 Jan 2011 20:22:54 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please revert nouveau.
In-Reply-To: <AANLkTim5-oQO4i7bc5mZZogXfuiHc_qk6S1Bz1eA83__@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1101162019530.13377@swampdragon.chaosbits.net>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com> <AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com> <AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com> <AANLkTimG+61dj-KNeAJZLta4+r1TyXyo1nO7VwJnxUW7@mail.gmail.com>
 <AANLkTikfp56XBE+B0hvvYD2nSJXpQ65XO7gwL2ZLU5uU@mail.gmail.com> <AANLkTimyrHqDpG4DmLym5AeHBbWziETDXjvBU+eaFfcb@mail.gmail.com> <AANLkTim5-oQO4i7bc5mZZogXfuiHc_qk6S1Bz1eA83__@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-749714665-1295205774=:13377"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-749714665-1295205774=:13377
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 16 Jan 2011, Anca Emanuel wrote:

> On Sun, Jan 16, 2011 at 8:56 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Sun, Jan 16, 2011 at 10:50 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> >>
> >> after
> >> git revert dfe63bb0ad9810db13aab0058caba97866e0a681
> >
> > You are aware that that was already reverted yesterday? See commit 3632ef89.
> >
> >> and
> >>
> >> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> >> index 5c4f9b9..2aad663 100644
> >> --- a/drivers/gpu/drm/drm_fb_helper.c
> >> +++ b/drivers/gpu/drm/drm_fb_helper.c
> >> @@ -816,6 +816,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
> >>                        mutex_unlock(&dev->mode_config.mutex);
> >>                        return ret;
> >>                }
> >> +               drm_fb_helper_fill_fix(info, fb_helper->fb->pitch,
> >> fb_helper->fb->depth);
> >>        }
> >>        mutex_unlock(&dev->mode_config.mutex);
> >>
> >> I have an partial working sistem.
> >
> > What does "partial working system" even MEAN?
> >
> > Anca, stop emailing worthless crap. Tell what the problems are. And cc
> > the right people rather than asking me personally to just "revert"
> > without even saying what the problem is. And if you feel like they
> > have been ignoring you, then I have a clue for you: I bet they have
> > been frustrated by the same things I am frustrated by.
> >
> > IOW, do a nice proper bug-report. Do it to the right people. Include
> > useful information, and remember that the developers DO NOT see the
> > problem you have (if they did, they'd not have done the changes), so
> > "doesn't work" or "the boot screen is not ok" is not something anybody
> > is ever going to find useful.
> >
> >         Linus
> >
> 
> Linus, I am a beginner, I will try to be more useful in the future.

Here's a bug report form that will help you include relevant info: 
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html

To see what the right people to send your report to are, check the 
MAINTAINERS file, the CREDITS file, possibly names listed at the top of 
relevant source files, 'git blame <file in question>' is also sometimes 
useful to come up with names of people who might be interested.
After adding all the right people to the mail, adding lkml to CC is 
usually a good idea.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-749714665-1295205774=:13377--

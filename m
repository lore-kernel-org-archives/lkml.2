Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1JWArj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 20:47:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43319 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1JWAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 20:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <9983.1319261492@turing-police.cc.vt.edu>
References: <CA+55aFy0BH=XUCP7gHgZEc3nrTNEGeZLn1Q_ekofyEHvJZYNVQ@mail.gmail.com>
 <12633.1319228151@turing-police.cc.vt.edu> <CA+55aFzLTjB+CwB7MQNh+p0pjSrFd=pBFDcA=GxMY4HJhQokUg@mail.gmail.com>
 <9983.1319261492@turing-police.cc.vt.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 03:47:16 +0300
X-Google-Sender-Auth: h-hUiJkxofTvb7WK4T8_L6mRxE0
Message-ID: <CA+55aFygxqqz_67c9n2PtwZEWgpRMCdCpUhZK-xvdqW-BJ0LLA@mail.gmail.com>
Subject: Re: Linux 3.1-rc10
To: Valdis.Kletnieks@vt.edu
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 8:31 AM,  <Valdis.Kletnieks@vt.edu> wrote:
>
> Actually, the question was "Are there enough Linus cycles to do KS
> and all the merges in 2 weeks?". ;)

I think there will be.

The kernel summit is only two days, and then I have another day of
LinuxCon Europe, and basically a day of travel. So it's four days out
of the 2 weeks, and I can actually do the time-consuming part of the
merges while traveling (ie *looking* at them if I need to: the
technical merge action itself is usually never the problem).

Additionally, the first few days (which is KS/etc), I'll probably be
merging mainly from people who have already got k.org accounts because
they got into the trust network early, so it's going to be slightly
limited by the fact that it will invariably take some time to get the
gpg signing and k.org account setup a day or two.

So I'm not horribly worried.

What worries me more than the kernel summit is just that the 3.1
release cycle has dragged out longer than usual, so I'm a bit afraid
that the 3.2 merge window will just be more chaotic than usual just
because there might be more stuff there to be merged. But that's
independent of any KS issues, and I also suspect that the added time
for development has been largely nullified by the productivity lost
due to the k.org mess.

linux-next is pretty large, but I don't track historical sizes all
that well, so I can't say if it's noticeably larger than it usually
is. Stephen may know, but he's on vacation right now.

So we'll see.

                    Linus

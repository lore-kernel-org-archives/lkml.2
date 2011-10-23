Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1JWHmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 03:42:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36714 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1JWHme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 03:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tympvK8O3NC20CFG-2TutozHUKZTird7MpNUQi5BY=sww@mail.gmail.com>
References: <CA+55aFy0BH=XUCP7gHgZEc3nrTNEGeZLn1Q_ekofyEHvJZYNVQ@mail.gmail.com>
 <12633.1319228151@turing-police.cc.vt.edu> <CA+55aFzLTjB+CwB7MQNh+p0pjSrFd=pBFDcA=GxMY4HJhQokUg@mail.gmail.com>
 <9983.1319261492@turing-police.cc.vt.edu> <CA+55aFygxqqz_67c9n2PtwZEWgpRMCdCpUhZK-xvdqW-BJ0LLA@mail.gmail.com>
 <CAPM=9tympvK8O3NC20CFG-2TutozHUKZTird7MpNUQi5BY=sww@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 10:42:11 +0300
X-Google-Sender-Auth: PicXBElfx-QnTR_Dy4amTq-QvtU
Message-ID: <CA+55aFy3GHzho33yki0=c=Hh4GuJY_+DPqn7esw-AF8KZ0=AbQ@mail.gmail.com>
Subject: Re: Linux 3.1-rc10
To: Dave Airlie <airlied@gmail.com>
Cc: Valdis.Kletnieks@vt.edu,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 9:16 AM, Dave Airlie <airlied@gmail.com> wrote:
>
> Are you going to accept pull requests from non-k.org remotes?

For something like freedesktop.org, I have no trouble at all. It's the
totally anonymous trees that I don't want to worry about - they've
been ok for the later part of the -rc stage, when the commits are few
and small and I can just verify that it all looks ok, but for big
changes I definitely want more of a trustworthy source.

Oh, but make sure your pull requests are valid. Look at the pull
requests you've been sending me: they have things like "~/" in them,
which probably works for you, but does *not* work for me. You need to
make it "~airlied/" or whatever. Again, fixing things like that up is
fine when I only have a few small pull requests, but it's a major pain
in the rear during the chaos that is the merge window.

Thanks,
          Linus

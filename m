Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1JVDIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 23:08:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47388 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1JVDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 23:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <12633.1319228151@turing-police.cc.vt.edu>
References: <CA+55aFy0BH=XUCP7gHgZEc3nrTNEGeZLn1Q_ekofyEHvJZYNVQ@mail.gmail.com>
 <12633.1319228151@turing-police.cc.vt.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Oct 2011 06:08:31 +0300
X-Google-Sender-Auth: p4iyRTl-P7VjToJ7RvOJugf7ajE
Message-ID: <CA+55aFzLTjB+CwB7MQNh+p0pjSrFd=pBFDcA=GxMY4HJhQokUg@mail.gmail.com>
Subject: Re: Linux 3.1-rc10
To: Valdis.Kletnieks@vt.edu
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 11:15 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> Are there plans to extend the merge window because everybody will be busy at
> KS, or is the plan to do KS during the day, do merges at night, and resume
> sleeping after -rc1 gets out?

Why the hell would you do merges at night?

If the code isn't ready by the kernel summit, you don't ask me to
pull. It's that easy.

It's ALWAYS that easy. Your argument is totally flawed. The only one
who should be busy during the merge window is *me*. If you're busy
during th emerge window, you're doing something wrong.

So what you should do is:

 - get your git tree ready.

 - during the KS, if you haven't already, get your gpg key signed so
that you can get a kernel.org account

 - push out your git tree to kernel.org

 - drink beer

Seriously. I'm not going to extend the merge window at all. Because we
extended the time when you could do your actual work already - if you
waited until the merge window to do work, then I don't want to see
your pull request ANYWAY. I'll take it the *next* merge window, thank
you very much.

So stop this idiotic "but but but, I'll be busy". If you think you'll
be busy doing development during the merge window, and don't have
enough time with the kernel summit going on at the same time, I
really* really really don't want to see any pull requests from you.

                    Linus

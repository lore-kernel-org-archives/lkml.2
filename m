Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2ASX6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:58:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2ASX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:58:50 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 15:58:28 -0800
X-Google-Sender-Auth: k9SRfDGL_53ekOtxideW2KAgseg
Message-ID: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
Subject: Linux 3.3-1 out - merge window closed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the subject says it all. It's been two weeks(+a day), and 3.3-rc1 is now out.

There are a couple of trees I haven't merged on purpose, and there may
be a few trees I overlooked by mistake. The "on purpose" ones were
things that looked unfamiliar and I felt I didn't have the bandwidth
to check. The "mistake" ones would just be things I missed due to
being busy.

And it really was a pretty busy merge window. I don't know *why* it
felt so busy, though. In pure numbers, the merge window seems to have
been pretty normal - the number of merges and regular commits are
right where you'd expect them. Part of it was spending what felt like
(and I think was) a couple of days chasing down two independent
suspend/resume regressions on my laptop, part of it was a couple of
just bad pull requests, and some of it was some of the independent
discussions that were on-going. But none of that is unheard of, so
what do I know..

Anyway, it's out now, and I'm taking off early for a weekend of beer,
skiing and poker (not necessarily in that order: "don't drink and
ski"). No email.

So if you felt that your pull request was overlooked by mistake (or
intentionally, but really not so scary that you think I should have a
really easy time checking it), you have a couple of days to marshal
your arguments for why I should pull it after all.

And if you didn't send your pull request in time: "Phhhthrthtpt!". No
arguments for that one.

(Stats for those that like them: 20% arch updates (arm, power, mips,
x86), 60% drivers (networking - wireless in particular, staging,
media, dri, sound, misc - including getting rid of 'struct sysdev'),
and 20% random stuff: filesystems, networking, perf etc)

                              Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0K1Tcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:32:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab0K1Tcl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:32:41 -0500
MIME-Version: 1.0
In-Reply-To: <1290954299.30515.15.camel@marge.simson.net>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Nov 2010 11:31:41 -0800
Message-ID: <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
>
> Something else is seriously wrong though.  36.1 with attached (plus
> sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> 37.git and tip with fixlet below both suck rocks.  With a make -j40
> running, wakeup-latency is showing latencies of >100ms, amarok skips,
> mouse lurches badly.. generally horrid.  Something went south.

Can you test -rc3? Is that still ok? And are you perhaps using
Nouveau? There's a report of some graphics (?) regression since -rc3
about bad desktop performance:

   https://bugzilla.kernel.org/show_bug.cgi?id=23912

but it doesn't have any more information yet (so if -rc3 _is_ good for
you, and you can add anything to that report, it would be good. The
original reporter is hopefully bisecting it now)

                     Linus

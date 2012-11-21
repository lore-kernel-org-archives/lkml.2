Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2KUIjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:39:41 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51721 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2KUIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:39:40 -0500
MIME-Version: 1.0
In-Reply-To: <20121120175647.GA23532@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
	<20121119162909.GL8218@suse.de>
	<20121119191339.GA11701@gmail.com>
	<20121119211804.GM8218@suse.de>
	<20121119223604.GA13470@gmail.com>
	<CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
	<20121120071704.GA14199@gmail.com>
	<20121120152933.GA17996@gmail.com>
	<20121120175647.GA23532@gmail.com>
Date: Wed, 21 Nov 2012 16:39:39 +0800
Message-ID: <CAGjg+kHKaQLcrnEftB+2mjeCjGUBiisSOpNCe+_9-4LDho9LpA@mail.gmail.com>
Subject: Re: numa/core regressions fixed - more testers wanted
From: Alex Shi <lkml.alex@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Those of you who would like to test all the latest patches are
> welcome to pick up latest bits at tip:master:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master
>

I am wondering if it is a problem, but it still exists on HEAD: c418de93e39891
http://article.gmane.org/gmane.linux.kernel.mm/90131/match=compiled+with+name+pl+and+start+it+on+my

like when just start 4 pl tasks, often 3 were running on node 0, and 1
was running on node 1.
The old balance will average assign tasks to different node, different core.

Regards
Alex

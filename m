Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab2LQCxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:53:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LQCxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:53:41 -0500
Date: Sun, 16 Dec 2012 18:53:42 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1212161850060.1626@eggly.anvils>
References: <20121212100338.GS1009@suse.de> <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2012, Linus Torvalds wrote:
> On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
> > This is a pull request for "Automatic NUMA Balancing V11". The list
> 
> Ok, guys, I've pulled this and pushed out. There were some conflicts
> with both the VM changes and with the scheduler tree, but they were
> pretty small and looked simple, so I fixed them up and hope they all
> work.

Great! Thank you. Rejoicing on all sides.
One small merge fixup follows under new subject.

Hugh

> 
> Has anybody tested the impact on single-node systems? If distros
> enable this by default (and it does have 'default y', which is a big
> no-no for new features - I undid that part) then there will be tons of
> people running this without actually having multiple sockets. Does it
> gracefully avoid pointless overheads for this case?
> 
> Anyway, hopefully we'll have a more real numa balancing for 3.9, and
> this is still considered a reasonable base for that work.
> 
>                   Linus

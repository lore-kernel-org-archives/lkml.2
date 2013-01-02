Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3ABTvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:51:48 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46779 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABTvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:51:46 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 14:51:45 EST
MIME-Version: 1.0
In-Reply-To: <CA+55aFza356-L4F2RC1UP3ujDLoTU2352s3o171mQOQHJRaktw@mail.gmail.com>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
 <1353624594-1118-19-git-send-email-mingo@kernel.org> <alpine.DEB.2.00.1212031644440.32354@chino.kir.corp.google.com>
 <CA+55aFyrSVzGZ438DGnTFuyFb1BOXaMmvxtkW0Xhnx+BxAg2PA@mail.gmail.com>
 <alpine.DEB.2.00.1212201440250.7807@chino.kir.corp.google.com>
 <20121221134740.GC13367@suse.de> <CA+55aFxrdPpMWLD8LF0NNqgJqmB-L-HW3Xyxht6e5AwnoaueTw@mail.gmail.com>
 <20121221195817.GE13367@suse.de> <CA+55aFwDXj3LqCRepsaeZMjOg0YsWV=7GFLHqHe2CxoF4JchCQ@mail.gmail.com>
 <20121221231024.GG13367@suse.de> <CA+55aFza356-L4F2RC1UP3ujDLoTU2352s3o171mQOQHJRaktw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 2 Jan 2013 14:43:46 -0500
X-Google-Sender-Auth: oFR_8nQ-4rAkmNdwUse312utMuc
Message-ID: <CAHGf_=o7PBt1y=nBFqH17zoY+Wj1mzQm3XJLSNKG1s0_XCCcNw@mail.gmail.com>
Subject: Re: [patch] mm, mempolicy: Introduce spinlock to read shared policy tree
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, this looks fine to me, but I'd like to get a sign-off from Kosaki
> too, and I guess it's really not all that urgent, so I can do the -rc1
> release tonight without worrying about it, knowing that a fix is at
> least pending, and that nobody is likely to actually ever hit the
> problem in practice anyway.

Sorry for the looooong time silince. I broke my stomach and I didn't actively
developed last year. I apologize this.

Anyway, I ran basic tests of mempolicy again and I have no seen any
failure. Thus

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


Thank you.

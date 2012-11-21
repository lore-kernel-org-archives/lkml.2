Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2KURp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:45:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KURpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:45:55 -0500
Message-ID: <50AD1333.7070900@redhat.com>
Date: Wed, 21 Nov 2012 12:45:23 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
References: <1353291284-2998-1-git-send-email-mingo@kernel.org> <20121119162909.GL8218@suse.de> <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com> <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com> <20121120060014.GA14065@gmail.com> <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com> <20121120074445.GA14539@gmail.com> <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com> <20121120090637.GA14873@gmail.com> <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
In-Reply-To: <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 12:02 PM, Linus Torvalds wrote:

> The same is true of all your arguments about Mel's numbers wrt THP
> etc. Your arguments are misleading - either intentionally, of because
> you yourself didn't think things through. For schednuma, it's not
> enough to be par with mainline with THP off - the competition
> (autonuma) has been beating mainline soundly in Mel's configuration.
> So the target to beat is not mainline, but the much *higher*
> performance that autonuma got.

Once the numa base patches are upstream, the bar will be raised
automatically.

With the same infrastructure in place, we will be able to do
an apples to apples comparison of the NUMA placement policies,
and figure out which one will be the best to merge.

-- 
All rights reversed

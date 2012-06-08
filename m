Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549Ab2FHXGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:06:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989Ab2FHXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:06:13 -0400
Date: Fri, 8 Jun 2012 16:06:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Message-Id: <20120608160612.dea6d1ce.akpm@linux-foundation.org>
In-Reply-To: <87lik920h8.fsf@skywalker.in.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
	<20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
	<87lik920h8.fsf@skywalker.in.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012 20:13:31 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> >> 
> >>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
> >>    mm/memcontrol.c beyond its current 5650 lines, and
> >> 
> >
> > I can definitely look at spliting mm/memcontrol.c 
> >
> >
> >>  - performance: not incurring any overhead of enabling memcg for per-
> >>    page tracking that is unnecessary if users only want to limit hugetlb 
> >>    pages.
> >> 
> 
> Since Andrew didn't sent the patchset to Linus because of this
> discussion, I looked at reworking the patchset as a seperate
> controller. The patchset I sent here
> 
> http://thread.gmane.org/gmane.linux.kernel.mm/79230
> 
> have seen minimal testing. I also folded the fixup patches
> Andrew had in -mm to original patchset.
> 
> Let me know if the changes looks good.

This is starting to be a problem.  I'm still sitting on the old version
of this patchset and it will start to get in the way of other work.

We now have this new version of the patchset which implements a
separate controller but it is unclear to me which way we want to go.

Can the memcg developers please drop everything else and make a
decision here?

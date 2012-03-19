Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2CSJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:15:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48225 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2CSJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:15:35 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 09/10] memcg: move HugeTLB resource count to parent cgroup on memcg removal
In-Reply-To: <4F66A258.5060301@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A258.5060301@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Mar 2012 14:30:24 +0530
Message-ID: <87r4wpj787.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031909-4790-0000-0000-000001DA4D92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 12:04:56 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This add support for memcg removal with HugeTLB resource usage.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 
> seems ok for now.
> 
> Now, Tejun and Costa, and I are discussing removeing -EBUSY from rmdir().
> We're now considering 'if use_hierarchy=false and parent seems full, 
> reclaim all or move charges to the root cgroup.' then -EBUSY will go away.
> 
> Is it accesptable for hugetlb ? Do you have another idea ?
> 

That should work even for hugetlb. 

-aneesh


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2CSJUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:20:03 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38400 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab2CSJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:20:02 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 08/10] hugetlbfs: Add a list for tracking in-use HugeTLB pages
In-Reply-To: <4F66A15B.7070804@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A15B.7070804@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Mar 2012 14:29:14 +0530
Message-ID: <87ty1lj7a5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031908-9574-0000-0000-000001DF3811
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 12:00:43 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > hugepage_activelist will be used to track currently used HugeTLB pages.
> > We need to find the in-use HugeTLB pages to support memcg removal.
> > On memcg removal we update the page's memory cgroup to point to
> > parent cgroup.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> seems ok to me but...why the new list is not per node ? no benefit ?
> 

I am not sure whether having per node will bring any performance
benefit. For cgroup removal we need to look at all the list entries
anyway. 

-aneesh


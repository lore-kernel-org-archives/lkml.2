Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2FJPE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 11:04:59 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42328 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2FJPE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 11:04:58 -0400
Date: Sun, 10 Jun 2012 20:34:10 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mgorman@suse.de, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        dhillf@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Message-ID: <20120610150410.GA11204@skywalker.linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com>
 <20120608160612.dea6d1ce.akpm@linux-foundation.org>
 <87zk8cfu3v.fsf@skywalker.in.ibm.com>
 <alpine.DEB.2.00.1206091853580.7832@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206091853580.7832@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12061015-3864-0000-0000-000003447F14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 06:55:30PM -0700, David Rientjes wrote:
> On Sat, 9 Jun 2012, Aneesh Kumar K.V wrote:
> 
> > David Rientjes didn't like HugetTLB limit to be a memcg extension and
> > wanted this to be a separate controller. I posted a v7 version that did
> > HugeTLB limit as a separate controller and used page cgroup to track
> > HugeTLB cgroup. Kamezawa Hiroyuki didn't like the usage of page_cgroup
> > in HugeTLB controller( http://mid.gmane.org/4FCD648E.90709@jp.fujitsu.com )
> > 
> 
> Yes, and thank you very much for working on v8 to remove the dependency on 
> page_cgroup and to seperate this out.  I think it will benefit users who 
> don't want to enable all of memcg but still want to account and restrict 
> hugetlb page usage, and I think the code seperation is much cleaner 
> internally.
> 

I have V9 ready to post. Only change I have against v8 is to fix the compund_order
comparison and folding the charge/uncharge patches with its users. I will wait for
your review feedback before posting V9 so that I can address the review comments
in V9. Once we get V9 out we can get the series added to -mm ?

> I'll review that patchset and suggest that the old hugetlb extension in 
> -mm be dropped in the interim.
> 

I also agree with dropping the old hugetlb extension patchset in -mm.

-aneesh


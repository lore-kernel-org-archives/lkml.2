Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2FJBze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 21:55:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50925 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FJBzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 21:55:32 -0400
Date: Sat, 9 Jun 2012 18:55:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mgorman@suse.de, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        dhillf@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <87zk8cfu3v.fsf@skywalker.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1206091853580.7832@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87zk8cfu3v.fsf@skywalker.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Aneesh Kumar K.V wrote:

> David Rientjes didn't like HugetTLB limit to be a memcg extension and
> wanted this to be a separate controller. I posted a v7 version that did
> HugeTLB limit as a separate controller and used page cgroup to track
> HugeTLB cgroup. Kamezawa Hiroyuki didn't like the usage of page_cgroup
> in HugeTLB controller( http://mid.gmane.org/4FCD648E.90709@jp.fujitsu.com )
> 

Yes, and thank you very much for working on v8 to remove the dependency on 
page_cgroup and to seperate this out.  I think it will benefit users who 
don't want to enable all of memcg but still want to account and restrict 
hugetlb page usage, and I think the code seperation is much cleaner 
internally.

I'll review that patchset and suggest that the old hugetlb extension in 
-mm be dropped in the interim.

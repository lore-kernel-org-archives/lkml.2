Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2IKRng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:43:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63341 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2IKRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:43:24 -0400
Date: Tue, 11 Sep 2012 10:43:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911174319.GO7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <504F30DB.60808@huawei.com>
 <20120911170837.GM7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911170837.GM7677@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 11, 2012 at 10:08:37AM -0700, Tejun Heo wrote:
> > So isn't cpuset broken too? child cpuset's cpu mask isn't necessary a subset
> > of the parent's if the cpu_exclusive flag is not set.
> 
> Heh, didn't even look at that.  Just assumed it was in the same boat
> w/ cpu{acct}.  Will take a look.

Hmm... Looked at it and I don't think hierarchy support is broken w/
or w/o exclusive.  Can you please elaborate?

Thanks.

-- 
tejun

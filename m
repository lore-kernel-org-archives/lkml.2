Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab2ILQel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:34:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53082 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab2ILQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:34:38 -0400
Date: Wed, 12 Sep 2012 09:34:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120912163433.GL7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <504F30DB.60808@huawei.com>
 <20120911170837.GM7677@google.com>
 <20120911174319.GO7677@google.com>
 <505057D8.4010908@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505057D8.4010908@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 12, 2012 at 01:37:28PM +0400, Glauber Costa wrote:
> "If a cpuset is cpu or mem exclusive, no other cpuset, other than
> a direct ancestor or descendant, may share any of the same CPUs or
> Memory Nodes."
> 
> So I think it tricked me as well. I was under the impression that
> "exclusive" would also disallow the kids.

You two are confusing me even more.  AFAICS, the hierarchical
properties don't seem to change whether exclusive is set or not.  It
still ensures children can't have something parent doesn't allow and
exclusive applies to whether to share something with siblings, so I
don't think anything is broken hierarchy-wise.  Am I missing
something?  If so, please be explicit and elaborate where and how it's
broken.

Thanks.

-- 
tejun

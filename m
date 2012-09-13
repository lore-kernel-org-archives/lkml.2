Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2IMRVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:21:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48600 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2IMRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:21:42 -0400
Date: Thu, 13 Sep 2012 10:21:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913172137.GZ7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <5050568B.9090601@parallels.com>
 <20120912154907.GW21579@dhcp22.suse.cz>
 <20120912171120.GP7677@google.com>
 <5051CB24.4010801@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051CB24.4010801@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Sep 13, 2012 at 04:01:40PM +0400, Glauber Costa wrote:
> This is getting confusing for me as well, because I don't know if your
> reply was targeted towards me or Michal. As for me, I am in agreement
> with what you did, and I merely replied to Michal's concern and
> suggestion of not warning in the special 1-st level only setups saying I
> side with you.

Oh, I was replying to Michal.  I thought there was behavior difference
with the .use_hierarchy=0 cases that Michal was talking about but I
don't think that's the case and Michal is trying to say that we
shouldn't warn if the configuration behaves identical to
root.use_hierarchy=1 even if it contains some .use_hierarchy=0's,
which I'm fine with.

Thanks.

-- 
tejun

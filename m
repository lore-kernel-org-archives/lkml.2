Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927Ab2ILRM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:12:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760872Ab2ILRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:11:25 -0400
Date: Wed, 12 Sep 2012 10:11:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20120912171120.GP7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <5050568B.9090601@parallels.com>
 <20120912154907.GW21579@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912154907.GW21579@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 12, 2012 at 05:49:07PM +0200, Michal Hocko wrote:
> > While I respect your goal of not warning about any configuration
> > with max_level = 1, I believe the only sane configuration as soon
> > as we get any 2nd-level child is use_hierarchy = 1 for everybody.
> > 
> > Everything aside from it should be warned.
> 
> Defintely. And that what the above guarantess, doesn't it?

I'm getting a bit worried that I might not be fully understanding what
your concern is.  Can you please elaborate what your worries are and
the transition plan that you have in your mind regarding
.use_hierarchy?

Thanks.

-- 
tejun

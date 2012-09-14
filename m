Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2INTPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:15:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2INTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:15:14 -0400
Date: Fri, 14 Sep 2012 12:15:09 -0700
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
Message-ID: <20120914191509.GN17747@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <5050568B.9090601@parallels.com>
 <20120912154907.GW21579@dhcp22.suse.cz>
 <20120912171120.GP7677@google.com>
 <20120913121438.GC8055@dhcp22.suse.cz>
 <20120913171832.GY7677@google.com>
 <20120913173958.GA21381@dhcp22.suse.cz>
 <5052E87A.1050405@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052E87A.1050405@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:19:06PM +0400, Glauber Costa wrote:
> I want oppose it as well, but I believe part of this exercise is to make
> the need to have hierarchy widespread. Warning on the case
> 1st-level-only case helps with that, even if we make more noise than we
> should.
> 
> The reason I supported Tejun's proposal originally, is that I think that
> if we make the wrong amount of noise, being wrong by a surplus is better
> than being wrong by a deficit, in this case.

I think both are valid points and don't think it makes a lot of
difference either way.  Michal being the maintainer of the code, I'm
taking his approach for this one.

Thanks.

-- 
tejun

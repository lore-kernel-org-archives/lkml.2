Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab2INRRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:17:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab2INRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:17:14 -0400
Date: Fri, 14 Sep 2012 10:17:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914171708.GC17747@google.com>
References: <20120913205827.GO7677@google.com>
 <1347613484.4340.132.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347613484.4340.132.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:04:44AM +0200, Mike Galbraith wrote:
> On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:
> 
> > 7. Misc issues
> > 
>    * Extract synchronize_rcu() from user interface?  Exporting grace
> periods to userspace isn't wonderful for dynamic launchers.

Aye aye.

Also,

* Update doc.

-- 
tejun

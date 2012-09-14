Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2INTt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:49:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2INTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:49:55 -0400
Date: Fri, 14 Sep 2012 12:49:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914194950.GQ17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
 <20120914192840.GG6221@redhat.com>
 <20120914194439.GP17747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914194439.GP17747@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:44:39PM -0700, Tejun Heo wrote:
> I think there currently is too much (broken) flexibility and intent to
> remove it.  That doesn't mean that removeing all flexibility is the
> right direction.  It inherently is a balancing act and I think the
> proposed solution is a reasonable tradeoff.  There's important
> difference between causing full overhead by default for all users and
> requiring some overhead when the use case at hand calls for the
> functionality.

That said, if someone can think of a better solution, I'm all ears.
One thing that *has* to be maintained is that it should be able to tag
a resource in such way that its associated controllers are
identifiable regardless of which task is looking at it.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2IUVkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:40:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2IUVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:40:07 -0400
Date: Fri, 21 Sep 2012 14:40:02 -0700
From: Tejun Heo <tj@kernel.org>
To: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120921214002.GA7694@google.com>
References: <20120913205827.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:
> 7. Misc issues
> 
>   * Sort & unique when listing tasks.  Even the documentation says it
>     doesn't happen but we have a good hunk of code doing it in
>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>     don't like it, scream.
> 
>   * At the PLC, pjt told me that assinging threads of a cgroup to
>     different cgroups is useful for some use cases but if we're to
>     have a unified hierarchy, I don't think we can continue to do
>     that.  Paul, can you please elaborate the use case?
> 
>   * Vivek brought up the issue of distributing resources to tasks and
>     groups in the same cgroup.  I don't know.  Need to think more
>     about it.

* Update docs.

* Clean up cftype->read/write*() mess.

* Use sane fs event mechanism.

* Drop userland helper based empty notification.  Argh...

-- 
tejun

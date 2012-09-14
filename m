Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2INWGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:06:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2INWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:06:12 -0400
Date: Fri, 14 Sep 2012 15:06:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
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
Message-ID: <20120914220607.GX17747@google.com>
References: <20120913205827.GO7677@google.com>
 <CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 14, 2012 at 06:03:16PM -0400, Dhaval Giani wrote:
> >
> >   * Sort & unique when listing tasks.  Even the documentation says it
> >     doesn't happen but we have a good hunk of code doing it in
> >     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
> >     don't like it, scream.
> 
> I think some userspace tools do assume the uniq bit. So if we can
> preserve that, great!

Can you point me to those?  If there are users depending on it, I
won't break it, at least for now, but I at least wanna know more about
them.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2INWDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:03:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34417 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2INWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120913205827.GO7677@google.com>
References: <20120913205827.GO7677@google.com>
Date: Fri, 14 Sep 2012 18:03:16 -0400
Message-ID: <CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw@mail.gmail.com>
Subject: Re: [RFC] cgroup TODOs
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Tejun Heo <tj@kernel.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>   * Sort & unique when listing tasks.  Even the documentation says it
>     doesn't happen but we have a good hunk of code doing it in
>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>     don't like it, scream.
>

I think some userspace tools do assume the uniq bit. So if we can
preserve that, great!

Thanks
Dhaval

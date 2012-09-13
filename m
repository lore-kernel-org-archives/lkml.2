Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2IMRwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:52:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49916 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2IMRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:52:21 -0400
Date: Thu, 13 Sep 2012 10:52:16 -0700
From: Tejun Heo <tj@kernel.org>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Michal Hocko <mhocko@suse.cz>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913175216.GB7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120913121629.GL7767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913121629.GL7767@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Daniel.

On Thu, Sep 13, 2012 at 01:16:29PM +0100, Daniel P. Berrange wrote:
> If you want application developers / users to understand this, then
> you really need to update the Documentation/cgroups/cgroups.txt file
> to provide suitable recommendations on use of hierarchies. As it
> stands today it arguably encourages apps to make use of arbitrary
> hierarchies. While some of the other docs (blkio-controller.txt) do
> describe the limitations of their implementation, they don't ever
> go as far as recommending against usage of hierarchies, which is
> what you seem to be saying.
>
> Just printing warning messages in the logs with no docs to explain
> the issues which cause the warnings is not friendly to users, and
> IMHO will just lead people to ignore the warnings.

Oh yeah, we definitely need to update the docs.  No doubt about it.
Will do.

Thanks.

-- 
tejun

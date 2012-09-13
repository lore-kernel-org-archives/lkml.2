Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2IMRyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:54:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50166 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab2IMRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:54:06 -0400
Date: Thu, 13 Sep 2012 10:54:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913175401.GC7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
 <20120912170933.GO7677@google.com>
 <5051CBAA.5040308@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051CBAA.5040308@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Glauber.

On Thu, Sep 13, 2012 at 04:03:54PM +0400, Glauber Costa wrote:
> > I might / probably work on it and am hoping to coerce Vivek into it
> > too.  If you wanna jump in, please be my guest.
> 
> I am devoting part of my time to general cgroup stuff, I can definitely
> help you with that. Advantage is that you won't have to coerce me.

Yeah, that's awesome.  Would you be interested in looking into
implementing hierarchy support for blkcg too?  Or are you more
interested mostly in cgroup core and memcg?

Thanks!

-- 
tejun

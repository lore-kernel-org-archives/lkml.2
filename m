Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2IOCTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:19:55 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:44683 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2IOCTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:19:37 -0400
Date: Sat, 15 Sep 2012 02:20:37 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120915022037.GA6438@mail.hallyn.com>
References: <20120913205827.GO7677@google.com>
 <20120914183641.GA2191@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914183641.GA2191@cathedrallabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@ruivo.org):
> Tejun,
> On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:
> >   memcg can be handled by memcg people and I can handle cgroup_freezer
> >   and others with help from the authors.  The problematic one is
> >   blkio.  If anyone is interested in working on blkio, please be my
> >   guest.  Vivek?  Glauber?
> 
> if Serge is not planning to do it already, I can take a look in device_cgroup.

That's fine with me, thanks.

> also, heard about the desire of having a device namespace instead with
> support for translation ("sda" -> "sdf"). If anyone see immediate use for
> this please let me know.

Before going down this road, I'd like to discuss this with at least you,
me, and Eric Biederman (cc:d) as to how it relates to a device namespace.

thanks,
-serge

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab2INShL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:37:11 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:34894 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759685Ab2INShI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:37:08 -0400
Date: Fri, 14 Sep 2012 14:36:41 -0400
From: Aristeu Rozanski <aris@ruivo.org>
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
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914183641.GA2191@cathedrallabs.org>
References: <20120913205827.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,
On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:
>   memcg can be handled by memcg people and I can handle cgroup_freezer
>   and others with help from the authors.  The problematic one is
>   blkio.  If anyone is interested in working on blkio, please be my
>   guest.  Vivek?  Glauber?

if Serge is not planning to do it already, I can take a look in device_cgroup.

also, heard about the desire of having a device namespace instead with
support for translation ("sda" -> "sdf"). If anyone see immediate use for
this please let me know.

-- 
Aristeu


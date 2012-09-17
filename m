Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2IQNVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:21:40 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:38970 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2IQNVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:21:38 -0400
Date: Mon, 17 Sep 2012 09:21:02 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
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
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120917132102.GD28505@cathedrallabs.org>
References: <20120913205827.GO7677@google.com>
 <20120914183641.GA2191@cathedrallabs.org>
 <1347783557.2463.1.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347783557.2463.1.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 09:19:17AM +0100, James Bottomley wrote:
> On Fri, 2012-09-14 at 14:36 -0400, Aristeu Rozanski wrote:
> > also, heard about the desire of having a device namespace instead with
> > support for translation ("sda" -> "sdf"). If anyone see immediate use for
> > this please let me know.
> 
> That sounds like a really bad idea to me.  We've spent ages training
> users that the actual sd<x> name of their device doesn't matter and they
> should use UUIDs or WWNs instead ... why should they now care inside
> containers?

True, bad example on my part. The use case I had in mind when I wrote that
can be solved by symbolic links.

-- 
Aristeu


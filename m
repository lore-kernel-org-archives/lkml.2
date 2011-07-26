Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1GZTFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:05:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1GZTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:04:50 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=1gfTn2teGlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_-IuOyh5tuNKMDGD5yMA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] cgroup/kmemcheck: Annotate alloc_page() for cgroup
 allocations
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20110726184342.GB26597@tiehlicka.suse.cz>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
	 <20110726173816.GA26597@tiehlicka.suse.cz>
	 <1311702110.3526.98.camel@gandalf.stny.rr.com>
	 <1311702244.3526.100.camel@gandalf.stny.rr.com>
	 <1311704249.3526.106.camel@gandalf.stny.rr.com>
	 <20110726184342.GB26597@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 15:04:48 -0400
Message-ID: <1311707088.21143.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 20:43 +0200, Michal Hocko wrote:

> Maybe just a nit. What about making 
> gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
> and use it at both places?

I actually thought about that, but was too lazy to do it ;)


> 
> Anyway feel free to add my:
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 

Thanks, I'll send out a v3 with the updates.

-- Steve



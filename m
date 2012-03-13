Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2CMOKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab2CMOKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:10:43 -0400
Date: Tue, 13 Mar 2012 10:10:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120313141032.GD29169@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <1331591568.18960.61.camel@twins>
 <20120312223944.GJ23255@google.com>
 <1331592241.18960.64.camel@twins>
 <20120312230416.GM23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312230416.GM23255@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 04:04:16PM -0700, Tejun Heo wrote:
> On Mon, Mar 12, 2012 at 11:44:01PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
> > > If we can get to the point where nesting is fully
> > > supported by every controller first, that would be awesome too. 
> > 
> > As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
> > nesting support out of the cpu-controller.. that stuff is such a pain.
> > Then again, I don't think the container people like this proposal --
> > they were the ones pushing for full hierarchy back when.
> 
> Yeah, the great pain of full hierarchy support is one of the reasons
> why I keep thinking about supporting mapping to flat hierarchy.  Full
> hierarchy could be too painful and not useful enough for some
> controllers.  Then again, cpu and memcg already have it and according
> to Vivek blkcg also had a proposed implementation, so maybe it's okay.
> Let's see.

Implementing hierarchy is a pain and is expensive at run time. Supporting
flat structure will provide path for smooth transition.

We had some RFC patches for blkcg hierarchy and that made things even more
complicated and we might not gain much. So why to complicate the code
until and unless we have a good use case.

Thanks
Vivek

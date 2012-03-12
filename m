Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab2CLXEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:04:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54792 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab2CLXEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:04:22 -0400
Date: Mon, 12 Mar 2012 16:04:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312230416.GM23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <1331591568.18960.61.camel@twins>
 <20120312223944.GJ23255@google.com>
 <1331592241.18960.64.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331592241.18960.64.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:44:01PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
> > If we can get to the point where nesting is fully
> > supported by every controller first, that would be awesome too. 
> 
> As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
> nesting support out of the cpu-controller.. that stuff is such a pain.
> Then again, I don't think the container people like this proposal --
> they were the ones pushing for full hierarchy back when.

Yeah, the great pain of full hierarchy support is one of the reasons
why I keep thinking about supporting mapping to flat hierarchy.  Full
hierarchy could be too painful and not useful enough for some
controllers.  Then again, cpu and memcg already have it and according
to Vivek blkcg also had a proposed implementation, so maybe it's okay.
Let's see.

Thanks.

-- 
tejun

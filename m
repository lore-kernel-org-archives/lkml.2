Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0HCXuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:50:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47611 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab0HCXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:50:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 08:45:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
        oleg@redhat.com
Subject: Re: [PATCH v4 0/2] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-Id: <20100804084523.768cd353.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100803125827.0822e6ab.akpm@linux-foundation.org>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100803125827.0822e6ab.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 12:58:27 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Jul 2010 19:56:49 -0400
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > This patch series implements a write function for the 'cgroup.procs'
> > per-cgroup file, which enables atomic movement of multithreaded
> > applications between cgroups. Writing the thread-ID of any thread in a
> > threadgroup to a cgroup's procs file causes all threads in the group to
> > be moved to that cgroup safely with respect to threads forking/exiting.
> > (Possible usage scenario: If running a multithreaded build system that
> > sucks up system resources, this lets you restrict it all at once into a
> > new cgroup to keep it under control.)
> 
> I can see how that would be useful.  No comments from anyone else?
> 

I think the feature itself is good and useful. I welcome this.

> patch 1/2 makes me cry with all those ifdefs.  Maybe helper functions
> would help, but not a lot.
> 
Add static inline functions ?


> patch 2/2 looks very complicated.

yes. that's a concern.
I'd like to look deeper, today.

Thanks,
-Kame


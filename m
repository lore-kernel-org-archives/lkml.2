Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2IEIrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:47:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab2IEIrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:47:45 -0400
Date: Wed, 5 Sep 2012 01:47:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl,
        pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50470EBF.9070109@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 05, 2012 at 12:35:11PM +0400, Glauber Costa wrote:
> > As long as cpuacct and cpu are separate, I think it makes sense to
> > assume that they at least could be at different granularity.  
> 
> If they are comounted, and more: forceably comounted, I don't see how to
> call them separate. At the very best, they are this way for
> compatibility purposes only, to lay a path that would allow us to get
> rid of the separation eventually.

I think this is where we disagree.  I didn't mean that all controllers
should be using exactly the same hierarchy when I was talking about
unified hierarchy.  I do think it's useful and maybe even essential to
allow differing levels of granularity.  cpu and cpuacct could be a
valid example for this.  Likely blkcg and memcg too.

So, I think it's desirable for all controllers to be able to handle
hierarchies the same way and to have the ability to tag something as
belonging to certain group in the hierarchy for all controllers but I
don't think it's desirable or feasible to require all of them to
follow exactly the same grouping at all levels.

Thanks.

-- 
tejun

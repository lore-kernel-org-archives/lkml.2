Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2JCWME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:12:04 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35469 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2JCWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:12:01 -0400
Date: Thu, 4 Oct 2012 07:11:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Message-ID: <20121003221151.GC19248@localhost>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-7-git-send-email-glommer@parallels.com>
 <20120926155108.GE15801@dhcp22.suse.cz>
 <5064392D.5040707@parallels.com>
 <20120927134432.GE29104@dhcp22.suse.cz>
 <50658B3B.9020303@parallels.com>
 <20120930082542.GH10383@mtj.dyndns.org>
 <5069542C.2020103@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069542C.2020103@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

Sorry about late replies.  I'be been traveling for the Korean
thanksgiving holidays.

On Mon, Oct 01, 2012 at 12:28:28PM +0400, Glauber Costa wrote:
> > That synchronous ref draining is going away.  Maybe we can do that
> > before kmemcg?  Michal, do you have some timeframe on mind?
> 
> Since you said yourself in other points in this thread that you are fine
> with some page references outliving the cgroup in the case of slab, this
> is a situation that comes with the code, not a situation that was
> incidentally there, and we're making use of.

Hmmm?  Not sure what you're trying to say but I wanted to say that
this should be okay once the scheduled memcg pre_destroy change
happens and nudge Michal once more.

Thanks.

-- 
tejun

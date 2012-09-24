Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2IXRrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:47:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55991 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2IXRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:47:47 -0400
Date: Mon, 24 Sep 2012 10:47:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 07/16] memcg: skip memcg kmem allocations in
 specified code regions
Message-ID: <20120924174742.GC7694@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-8-git-send-email-glommer@parallels.com>
 <20120921195929.GL7264@google.com>
 <50602343.6040806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50602343.6040806@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 24, 2012 at 01:09:23PM +0400, Glauber Costa wrote:
> > I can't say I'm a big fan of this approach.  If there are enough
> > users, maybe but can't we just annotate the affected allocations
> > explicitly?  Is this gonna have many more users?
> 
> What exactly do you mean by annotating the affected allocations?

IOW, can't you just pass down an extra argument / flag / whatever
instead?

Thanks.

-- 
tejun

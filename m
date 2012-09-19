Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2ISHo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:44:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52672 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2ISHo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:44:58 -0400
Message-ID: <5059772A.8020402@parallels.com>
Date: Wed, 19 Sep 2012 11:41:30 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 13/16] slab: slab-specific propagation changes.
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-14-git-send-email-glommer@parallels.com> <00000139da52bc21-06113921-5cf5-42b6-94e3-fe9763e909bc-000000@email.amazonses.com>
In-Reply-To: <00000139da52bc21-06113921-5cf5-42b6-94e3-fe9763e909bc-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 09:00 PM, Christoph Lameter wrote:
> On Tue, 18 Sep 2012, Glauber Costa wrote:
> 
>> When a parent cache does tune_cpucache, we need to propagate that to the
>> children as well. For that, we unfortunately need to tap into the slab core.
> 
> One of the todo list items for the common stuff is to have actually a
> common kmem_cache structure. If we add a common callback then we could put
> that also into the core.
> 

At this point, I'd like to keep it this way if possible. I agree that it
would be a lot better living in a common location, and I commit to
helping you to move in that direction.

But I see no reason to have this commonization to happen first, as a
pre-requisite for this.


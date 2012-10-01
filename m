Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2JAMqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:46:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39652 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab2JAMqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:46:36 -0400
Message-ID: <50698FD9.2040808@parallels.com>
Date: Mon, 1 Oct 2012 16:43:05 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 09/13] memcg: kmem accounting lifecycle management
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-10-git-send-email-glommer@parallels.com> <20121001121553.GG8622@dhcp22.suse.cz> <50698C97.70703@parallels.com> <20121001123654.GJ8622@dhcp22.suse.cz>
In-Reply-To: <20121001123654.GJ8622@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 04:36 PM, Michal Hocko wrote:
> On Mon 01-10-12 16:29:11, Glauber Costa wrote:
>> On 10/01/2012 04:15 PM, Michal Hocko wrote:
>>> Based on the previous discussions I guess this one will get reworked,
>>> right?
>>>
>>
>> Yes, but most of it stayed. The hierarchy part is gone, but because we
>> will still have kmem pages floating around (potentially), I am still
>> using the mark_dead() trick with the corresponding get when kmem_accounted.
> 
> Is it OK if I hold on with the review of this one until the next
> version?
> 
Of course.

I haven't sent it yet because I also received a lot more feedback for
the slab part (which is expected), and I want to get a least part of
that going before I send it again.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2IXMpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:45:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50927 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2IXMpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:45:09 -0400
Message-ID: <50605500.5050606@parallels.com>
Date: Mon, 24 Sep 2012 16:41:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<cgroups@vger.kernel.org>" <cgroups@vger.kernel.org>,
        "<kamezawa.hiroyu@jp.fujitsu.com>" <kamezawa.hiroyu@jp.fujitsu.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-mm@kvack.org>" <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com> <506015E7.8030900@parallels.com> <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
In-Reply-To: <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 04:41 PM, Christoph wrote:
> 
> On Sep 24, 2012, at 3:12, Glauber Costa <glommer@parallels.com> wrote:
> 
>> On 09/21/2012 10:14 PM, Tejun Heo wrote:
>>
>> The new caches will appear under /proc/slabinfo with the rest, with a
>> string appended that identifies the group.
> 
> There are f.e. meminfo files in the per node directories in sysfs. It would make sense to have a slabinfo file there (if you want to keep that around). Then the format would be the same.
> 

But that is orthogonal, isn't it? People will still expect to see it in
the old slabinfo file.


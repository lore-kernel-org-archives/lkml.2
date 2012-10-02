Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2JBJOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:14:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38884 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2JBJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:13:57 -0400
Message-ID: <506AAF7F.9030901@parallels.com>
Date: Tue, 2 Oct 2012 13:10:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 03/13] memcg: change defines to an enum
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-4-git-send-email-glommer@parallels.com> <20121001190652.GD23734@cmpxchg.org>
In-Reply-To: <20121001190652.GD23734@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 11:06 PM, Johannes Weiner wrote:
> On Tue, Sep 18, 2012 at 06:04:00PM +0400, Glauber Costa wrote:
>> This is just a cleanup patch for clarity of expression.  In earlier
>> submissions, people asked it to be in a separate patch, so here it is.
>>
>> [ v2: use named enum as type throughout the file as well ]
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Should probably be the first in the series to get the cleanups out of
> the way :-)
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
If you guys want to merge this separately, be my guest =)


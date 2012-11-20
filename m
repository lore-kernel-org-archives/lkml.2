Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2KTIeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:34:37 -0500
Received: from mx2.parallels.com ([64.131.90.16]:60114 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab2KTIeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:34:36 -0500
Message-ID: <50AB4095.6000502@parallels.com>
Date: Tue, 20 Nov 2012 12:34:29 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <50AB05B4.4000303@jp.fujitsu.com>
In-Reply-To: <50AB05B4.4000303@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 08:23 AM, Kamezawa Hiroyuki wrote:
> (2012/11/20 10:44), David Rientjes wrote:
>> While profiling numa/core v16 with cgroup_disable=memory on the command
>> line, I noticed mem_cgroup_count_vm_event() still showed up as high as
>> 0.60% in perftop.
>>
>> This occurs because the function is called extremely often even when
>> memcg
>> is disabled.
>>
>> To fix this, inline the check for mem_cgroup_disabled() so we avoid the
>> unnecessary function call if memcg is disabled.
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
I am fine with this as well.

Acked-by: Glauber Costa <glommer@parallels.com>


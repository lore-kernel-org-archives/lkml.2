Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551Ab2EQKQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:16:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44352 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761523Ab2EQKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:16:23 -0400
Message-ID: <4FB4CF7A.9090108@parallels.com>
Date: Thu, 17 May 2012 14:14:18 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 02/29] slub: fix slab_state for slub
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205151453460.18595@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151453460.18595@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 01:55 AM, David Rientjes wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>> When the slub code wants to know if the sysfs state has already been
>> initialized, it tests for slab_state == SYSFS. This is quite fragile,
>> since new state can be added in the future (it is, in fact, for
>> memcg caches). This patch fixes this behavior so the test matches
>>> = SYSFS, as all other state does.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>
> Acked-by: David Rientjes<rientjes@google.com>
>
> Can be merged now, there's no dependency on the rest of this patchset.

So, is anyone taking this? I plan another submission this week, let me 
know if I should include these two patches or not.

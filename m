Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2JJJ3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:29:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53016 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab2JJJ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:29:50 -0400
Message-ID: <50753FFF.6060102@parallels.com>
Date: Wed, 10 Oct 2012 13:29:35 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [patch for-linus] memcg, kmem: fix build error when CONFIG_INET
 is disabled
References: <alpine.DEB.2.00.1210092325500.9528@chino.kir.corp.google.com> <5075383A.1000001@parallels.com> <20121010092700.GD23011@dhcp22.suse.cz>
In-Reply-To: <20121010092700.GD23011@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 01:27 PM, Michal Hocko wrote:
> On Wed 10-10-12 12:56:26, Glauber Costa wrote:
>> On 10/10/2012 10:32 AM, David Rientjes wrote:
>>> Commit e1aab161e013 ("socket: initial cgroup code.") causes a build error 
>>> when CONFIG_INET is disabled in Linus' tree:
>>>
>> unlikely that something that old would cause a build bug now, specially
>> that commit, that actually wraps things inside CONFIG_INET.
>>
>> More likely caused by the recently merged
>> "memcg-cleanup-kmem-tcp-ifdefs.patch" in -mm by mhocko (CC'd)
> 
> Strange it didn't trigger during my (and Fenguang) build testing.

Fengguang mentioned to me while testing my kmemcg tree that were a build
error occurring in the base tree, IOW, yours.

Fengguang, was that this error? Why hasn't it showed up before in the
test system?



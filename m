Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2FZCr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 22:47:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33091 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2FZCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 22:47:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE92258.4040900@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 11:45:44 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Wanpeng Li <liwp.linux@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com> <4FE834D9.8070903@jp.fujitsu.com> <20120625104357.GB12148@kernel> <20120625110926.GJ19805@tiehlicka.suse.cz>
In-Reply-To: <20120625110926.GJ19805@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 20:09), Michal Hocko wrote:
> On Mon 25-06-12 18:43:57, Wanpeng Li wrote:
>> On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>>> (2012/06/25 17:44), Wanpeng Li wrote:
>>>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>>>
>>>> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>>>>
>>>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>>>
>>> I can't understand the benefit of this patch to the real world...
>>>
>>> So, if you wrote the patch description as "clean up" rather than optimize,
>>> ok, I'll agree.
>> OK, I will change to "Cleanup". Thank you Kame.
>
> Does this really clean something up?
>

I just thought unused variable is trash even if it disappears after complie.

Thanks,
-Kame



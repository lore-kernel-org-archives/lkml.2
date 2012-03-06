Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2CFLrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:47:45 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38302 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076Ab2CFLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:47:44 -0500
Message-ID: <4F55F916.1020502@parallels.com>
Date: Tue, 6 Mar 2012 15:46:30 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <jweiner@redhat.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm/memcg: scanning_global_lru means mem_cgroup_disabled
References: <20120229090748.29236.35489.stgit@zurg> <20120229091539.29236.57783.stgit@zurg> <20120302141251.4f434632.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120302141251.4f434632.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 09:12 AM, KAMEZAWA Hiroyuki wrote:
> On Wed, 29 Feb 2012 13:15:39 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> From: Hugh Dickins<hughd@google.com>
>>
>> Although one has to admire the skill with which it has been concealed,
>> scanning_global_lru(mz) is actually just an interesting way to test
>> mem_cgroup_disabled().  Too many developer hours have been wasted on
>> confusing it with global_reclaim(): just use mem_cgroup_disabled().
>>
>> Signed-off-by: Hugh Dickins<hughd@google.com>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> Acked-by: KAMEZWA Hiroyuki<kamezawa.hiroyu@jp.fujitu.com>
>
>
Acked-by: Glauber Costa <glommer@parallels.com>


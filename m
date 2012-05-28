Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2E1Ie7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 04:34:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37108 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2E1Ies (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 04:34:48 -0400
Message-ID: <4FC3381C.9020608@parallels.com>
Date: Mon, 28 May 2012 12:32:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz> <alpine.DEB.2.00.1205250933170.22597@router.home>
In-Reply-To: <alpine.DEB.2.00.1205250933170.22597@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 06:34 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Michal Hocko wrote:
>
>> On Fri 25-05-12 17:03:20, Glauber Costa wrote:
>>> I believe some of the early patches here are already in some trees around.
>>> I don't know who should pick this, so if everyone agrees with what's in here,
>>> please just ack them and tell me which tree I should aim for (-mm? Hocko's?)
>>> and I'll rebase it.
>>
>> memcg-devel tree is only to make development easier. Everything that
>> applies on top of this tree should be applicable to both -mm and
>> linux-next.
>> So the patches should go via traditional Andrew's channel.
>
> It would be best to merge these with my patchset to extract common code
> from the allocators. The modifications of individual slab allocators would
> then be not necessary anymore and it would save us a lot of work.
>
Some of them would not, some of them would still be. But also please 
note that the patches here that deal with differences between allocators 
are usually the low hanging fruits compared to the rest.

I agree that long term it not only better, but inevitable, if we are 
going to merge both.

But right now, I think we should agree with the implementation itself - 
so if you have any comments on how I am handling these, I'd be happy to 
hear. Then we can probably set up a tree that does both, or get your 
patches merged and I'll rebase, etc.




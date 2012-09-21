Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2IUJrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:47:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58880 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab2IUJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:47:14 -0400
Message-ID: <505C36D4.60303@parallels.com>
Date: Fri, 21 Sep 2012 13:43:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <CAOJsxLFVMYUxoVOcaCAtvwZmyMHS9mB3msP8gHn0a6NqzneLqQ@mail.gmail.com>
In-Reply-To: <CAOJsxLFVMYUxoVOcaCAtvwZmyMHS9mB3msP8gHn0a6NqzneLqQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 01:40 PM, Pekka Enberg wrote:
> Hi Glauber,
> 
> On Tue, Sep 18, 2012 at 5:11 PM, Glauber Costa <glommer@parallels.com> wrote:
>> This is a followup to the previous kmem series. I divided them logically
>> so it gets easier for reviewers. But I believe they are ready to be merged
>> together (although we can do a two-pass merge if people would prefer)
>>
>> Throwaway git tree found at:
>>
>>         git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab
>>
>> There are mostly bugfixes since last submission.
> 
> Overall, I like this series a lot. However, I don't really see this as a
> v3.7 material because we already have largeish pending updates to the
> slab allocators. I also haven't seen any performance numbers for this
> which is a problem.
> 
> So what I'd really like to see is this series being merged early in the
> v3.8 development cycle to maximize the number of people eyeballing the
> code and looking at performance impact.
> 
> Does this sound reasonable to you Glauber?

Absolutely.

As I've stated before, I actually believe the kmemcg-stack and
kmemcg-slab (this one) portions should be merged separately. (So we can
sort out issues more easily, and point to the right place)

The first one is a lot more stable and got a lot more love. The goal of
this one is to get it reviewed so we can merge as soon as we can - but
not sooner.

early v3.8 sounds perfect to me.

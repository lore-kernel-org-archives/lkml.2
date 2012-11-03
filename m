Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2KCDhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 23:37:20 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45066 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2KCDhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 23:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <50937918.7080302@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
 <20121101170454.b7713bce.akpm@linux-foundation.org> <50937918.7080302@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Fri, 2 Nov 2012 20:36:58 -0700
Message-ID: <CAHH2K0aRptCxJRxMVd=zHCHHc8nT4yj0OP0JDBM=HpTbg1R60A@mail.gmail.com>
Subject: Re: [PATCH v6 00/29] kmem controller for memcg.
To: Glauber Costa <glommer@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 12:41 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 11/02/2012 04:04 AM, Andrew Morton wrote:
>> On Thu,  1 Nov 2012 16:07:16 +0400
>> Glauber Costa <glommer@parallels.com> wrote:
>>
>>> Hi,
>>>
>>> This work introduces the kernel memory controller for memcg. Unlike previous
>>> submissions, this includes the whole controller, comprised of slab and stack
>>> memory.
>>
>> I'm in the middle of (re)reading all this.  Meanwhile I'll push it all
>> out to http://ozlabs.org/~akpm/mmots/ for the crazier testers.
>>
>> One thing:
>>
>>> Numbers can be found at https://lkml.org/lkml/2012/9/13/239
>>
>> You claim in the above that the fork worload is 'slab intensive".  Or
>> at least, you seem to - it's a bit fuzzy.
>>
>> But how slab intensive is it, really?
>>
>> What is extremely slab intensive is networking.  The networking guys
>> are very sensitive to slab performance.  If this hasn't already been
>> done, could you please determine what impact this has upon networking?
>> I expect Eric Dumazet, Dave Miller and Tom Herbert could suggest
>> testing approaches.
>>
>
> I can test it, but unfortunately I am unlikely to get to prepare a good
> environment before Barcelona.
>
> I know, however, that Greg Thelen was testing netperf in his setup.
> Greg, do you have any publishable numbers you could share?

I should have some netperf numbers next week.  Sorry I've been distracted by
other projects recently.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2BVNi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:38:57 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38699 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab2BVNiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:38:54 -0500
Message-ID: <4F44EFA6.2000104@parallels.com>
Date: Wed, 22 Feb 2012 17:37:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com> <1329917459.24994.14.camel@twins>
In-Reply-To: <1329917459.24994.14.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 05:30 PM, Peter Zijlstra wrote:
> On Tue, 2012-02-21 at 13:19 -0800, Tejun Heo wrote:
>> So, I mean, I don't know.  What do other people think?  Is this a
>> unnecessary worry?  Are people generally happy with the way things
>> are?  Lennart, Kay, what do you guys think?
>
> FWIW I'm all for ripping the orthogonal hierarchy crap out, I hate it
> just about as much as you do judging from your write-up.
>
> Yes it will make some people unhappy, but I can live with that since my
> life will be easier.. :-)
>
> I'm not sure on your process hierarchy pie though, I rather like being
> able to assign tasks to cgroups of my making without having to mirror
> that in the process hierarchy.
>
> Having seen what userspace does (libvirt in particular, I've still
> managed to not get infected by the systemd crap) its utterly and
> completely insane. Now I don't think any of my machines actually still
> have libvirt on it, so I don't care if we break that either ;-)
>
> Another thing I dislike about all the cgroup crap is all the dozens of
> tiny controllers being proposed left right and center. Like WTF isn't
> the hugetlb controller part of memcg? Its all memory, right?
>
Right. But this is easy to solve.
People are usually pointing out that "Hey, but that's not how my 
controller works, I need it to be slightly different here and there".
If we agree this is a bad thing - I think it is, we can at least adopt 
as a policy not to take any patches that create another hierarchy unless 
the need is utterly demonstrated.



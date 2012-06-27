Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab2F0MbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:31:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57674 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2F0MbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:31:01 -0400
Message-ID: <4FEAFC5E.4050104@parallels.com>
Date: Wed, 27 Jun 2012 16:28:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Kir Kolyshkin <kir@parallels.com>
Subject: Re: Fork bomb limitation in memcg WAS: Re: [PATCH 00/11] kmem controller
 for memcg: stripped down version
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <4FEAD260.4000603@parallels.com> <20120627122924.GD20638@somewhere.redhat.com>
In-Reply-To: <20120627122924.GD20638@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 04:29 PM, Frederic Weisbecker wrote:
> On Wed, Jun 27, 2012 at 01:29:04PM +0400, Glauber Costa wrote:
>> On 06/27/2012 01:55 AM, Andrew Morton wrote:
>>>> I can't speak for everybody here, but AFAIK, tracking the stack through
>>>> the memory it used, therefore using my proposed kmem controller, was an
>>>> idea that good quite a bit of traction with the memcg/memory people.
>>>> So here you have something that people already asked a lot for, in a
>>>> shape and interface that seem to be acceptable.
>>>
>>> mm, maybe.  Kernel developers tend to look at code from the point of
>>> view "does it work as designed", "is it clean", "is it efficient", "do
>>> I understand it", etc.  We often forget to step back and really
>>> consider whether or not it should be merged at all.
>>>
>>> I mean, unless the code is an explicit simplification, we should have
>>> a very strong bias towards "don't merge".
>>
>> Well, simplifications are welcome - this series itself was
>> simplified beyond what I thought initially possible through the
>> valuable comments
>> of other people.
>>
>> But of course, this adds more complexity to the kernel as a whole.
>> And this is true to every single new feature we may add, now or in
>> the
>> future.
>>
>> What I can tell you about this particular one, is that the justification
>> for it doesn't come out of nowhere, but from a rather real use case that
>> we support and maintain in OpenVZ and our line of products for years.
> 
> Right and we really need a solution to protect against forkbombs in LXC.
Small correction: In containers. LXC is not the only one out there =p



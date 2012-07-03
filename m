Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2GCLlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:41:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36160 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2GCLl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:41:29 -0400
Message-ID: <4FF2D9BF.20800@parallels.com>
Date: Tue, 3 Jul 2012 15:38:39 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
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
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <4FEAD260.4000603@parallels.com> <alpine.DEB.2.00.1206271233080.22162@chino.kir.corp.google.com> <4FEC1D63.6000903@parallels.com> <20120628152540.cc13a735.akpm@linux-foundation.org>
In-Reply-To: <20120628152540.cc13a735.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 02:25 AM, Andrew Morton wrote:
> On Thu, 28 Jun 2012 13:01:23 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>>
>> ...
>>
> 
> OK, that all sounds convincing ;) Please summarise and capture this
> discussion in the [patch 0/n] changelog so we (or others) don't have to
> go through this all again.  And let's remember this in the next
> patchset!

Thanks, will surely do.

>> Last, but not least, note that it is totally within my interests to
>> merge the slab tracking as fast as we can. it'll be a matter of going
>> back to it, and agreeing in the final form.
> 
> Yes, I'd very much like to have the whole slab implementation in a
> reasonably mature state before proceeding too far with this base
> patchset.

Does that means that you want to merge them together? I am more than
happy to post the slab part again ontop of that to have people reviewing it.

But if possible, I believe that merging this part first would help us to
split up testing in a beneficial way, in the sense that if it breaks, we
know at least in which part it is. Not to mention, of course, that
reviewers will have an easier time reviewing it as two pieces.




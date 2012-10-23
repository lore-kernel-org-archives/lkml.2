Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072Ab2JWUoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:44:16 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:15436 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933811Ab2JWUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:44:11 -0400
Date: Tue, 23 Oct 2012 20:44:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 16/18] slab: propagate tunables values
In-Reply-To: <5084FA31.4060709@parallels.com>
Message-ID: <0000013a8f5e3876-25f4d815-cf0a-4574-a321-60ad7a337aa7-000000@email.amazonses.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-17-git-send-email-glommer@parallels.com> <0000013a7a94c439-825659cc-8e6a-4905-909c-db1b230a4086-000000@email.amazonses.com> <5084FA31.4060709@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Glauber Costa wrote:

> On 10/19/2012 11:51 PM, Christoph Lameter wrote:
> > On Fri, 19 Oct 2012, Glauber Costa wrote:
> >
> >> SLAB allows us to tune a particular cache behavior with tunables.
> >> When creating a new memcg cache copy, we'd like to preserve any tunables
> >> the parent cache already had.
> >
> > SLAB and SLUB allow tuning. Could you come up with some way to put these
> > things into slab common and make it flexible so that the tuning could be
> > used for future allocators (like SLAM etc)?
> >
> They do, but they also do it very differently. Like slub uses sysfs,
> while slab don't.

Well yes that is something that I also want to make more general so that
all allocators support sysfs style display of status and tuning.

> I of course fully support the integration, I just don't think this
> should be a blocker for all kinds of work in the allocators. Converting
> slab to sysfs seems to be a major work, that you are already tackling.
> Were it simple, I believe it would be done already. Without it, this is
> pretty much a fake integration...

Well there is quite a bit of infrastructure that needs to be common in
order to get this done properly. I hope we will get around to that
someday.


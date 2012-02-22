Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2BVNbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:31:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:54286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2BVNbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:31:12 -0500
Message-ID: <1329917459.24994.14.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Date: Wed, 22 Feb 2012 14:30:59 +0100
In-Reply-To: <20120221211938.GE12236@google.com>
References: <20120221211938.GE12236@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 13:19 -0800, Tejun Heo wrote:
> So, I mean, I don't know.  What do other people think?  Is this a
> unnecessary worry?  Are people generally happy with the way things
> are?  Lennart, Kay, what do you guys think? 

FWIW I'm all for ripping the orthogonal hierarchy crap out, I hate it
just about as much as you do judging from your write-up.

Yes it will make some people unhappy, but I can live with that since my
life will be easier.. :-)

I'm not sure on your process hierarchy pie though, I rather like being
able to assign tasks to cgroups of my making without having to mirror
that in the process hierarchy.

Having seen what userspace does (libvirt in particular, I've still
managed to not get infected by the systemd crap) its utterly and
completely insane. Now I don't think any of my machines actually still
have libvirt on it, so I don't care if we break that either ;-)

Another thing I dislike about all the cgroup crap is all the dozens of
tiny controllers being proposed left right and center. Like WTF isn't
the hugetlb controller part of memcg? Its all memory, right?

Now I appreciate all this is new and exciting and Linux does the
evolutionary development thing so its bound to be a mess sometimes, but
shees.. 

So +1 on just ripping everything apart and trying again.



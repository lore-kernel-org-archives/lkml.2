Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2IEIOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:14:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2IEIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:14:45 -0400
Date: Wed, 5 Sep 2012 01:14:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl,
        pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047074D.1030104@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 05, 2012 at 12:03:25PM +0400, Glauber Costa wrote:
> The goal here is to have distributions to do it, because they tend to
> have a well defined lifecycle management, much more than upstream. Whoever
> sets this option, can coordinate with upstream.

Distros can just co-mount them during boot.  What's the point of the
config options?

> > Also, I really don't see much point in enforcing this almost arbitrary
> > grouping of controllers.  It doesn't simplify anything and using
> > cpuacct in more granular way than cpu actually is one of the better
> > justified use of multiple hierarchies.  Also, what about memcg and
> > blkcg?  Do they *really* coincide?  Note that both blkcg and memcg
> > involve non-trivial overhead and blkcg is essentially broken
> > hierarchy-wise.
> 
> Where did I mention memcg or blkcg in this patch ?

Differing hierarchies in memcg and blkcg currently is the most
prominent case where the intersection in writeback is problematic and
your proposed solution doesn't help one way or the other.  What's the
point?

Thanks.

-- 
tejun

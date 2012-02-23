Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2BWWfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:35:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2BWWfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:35:44 -0500
Date: Thu, 23 Feb 2012 14:34:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223223457.GJ22536@google.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <20120223213847.GK19691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223213847.GK19691@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 04:38:47PM -0500, Vivek Goyal wrote:
> On Thu, Feb 23, 2012 at 10:41:34AM +0100, Peter Zijlstra wrote:
> > On Wed, 2012-02-22 at 11:57 -0500, Vivek Goyal wrote:
> > > 
> > > Again, it does not mean I am advocating flat hiearchy. I am just wondering
> > > in case of fully nested hierarchies (task at same level as groups), how
> > > does one explain it to a layman user who understands things in terms of
> > > % of resources. 
> > 
> > If your complete control is % based then I would assume its a % of a %.
> > Simple enough.
> 
> But % of % will vary dynamically and not be static. So if root has got
> 100% of resources and we want 25% of that for a group, then hierarchy
> might look as follows.

It is complex but semantics is pretty well defined.  It should behave
exactly the same as HTB.  Whether the complexity would be justifiable
is a different issue.

Thanks.

-- 
tejun

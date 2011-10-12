Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1JLSQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:16:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36925 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1JLSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:16:48 -0400
Date: Wed, 12 Oct 2011 22:16:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111012181641.GZ15413@moon>
References: <1317943022.1095.25.camel@mop>
 <20111011161600.6145aa6b.akpm@linux-foundation.org>
 <20111012005935.GD14968@somewhere>
 <20111012174014.GE6281@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012174014.GE6281@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:40:14AM -0700, Tejun Heo wrote:
...
> 
> In general, I think making freezer work nicely with the rest of the
> system is a good idea and have been working towards that direction.
> Allowing a frozen task to be killed is not only handy for use cases
> like above but also makes solving freezer involved deadlocks much less
> likely and easier to solve.  Another that I have in mind is allowing
> ptrace from unfrozen task to a frozen task.  This can be helpful in
> general debugging (currently attaching to multi-threaded, violently
> cloning process is quite cumbersome) and userland checkpointing.

Yeah, being able to ptrace a frozen cgroup would be great for us.
We stick with signals start/stop cycle at moment but the final target
is the cgroups and freezer of course. (btw while were poking freezer
code I noticed that there is no shortcut to move all tasks in cgroup
into the root cgroup, so I guess say "echo -1 > tasks" might be a good
addition to move all tasks from some particular cgroup to the root
by single action).

> 
> I was working toward these and had some of the patches in Rafael's
> tree but then korg went down and we lost track of the tree and I had a
> pretty long vacation.  I can't say for sure but am aiming to achieve
> the goals during the next devel cycle.
>

This is a wishlist after all, so target is pointed and only time is
needed to implement all this ;)

	Cyrill

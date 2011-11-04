Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1KDMhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:37:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45917 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KDMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:37:13 -0400
Date: Fri, 4 Nov 2011 13:37:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111104123704.GB18994@somewhere>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com>
 <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
 <20111028163021.1ce61f8a.akpm@linux-foundation.org>
 <20111103170038.GG8198@somewhere.redhat.com>
 <4EB3549D.5090404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB3549D.5090404@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 10:57:33AM +0800, Li Zefan wrote:
> >>> There may be other ways to cobble this sort of safety together, but
> >>> they are less appealing for various reasons.  cgroups are how we
> >>> control groups of related pids.
> >>>
> >>> I'd really love to be able to use this.
> >>
> >> Has it been confirmed that this implementation actually solves the
> >> problem?  ie: tested a bit?
> >>
> >> btw, Frederic told me that this version of the patchset had some
> >> serious problem so it's on hold pending an upgrade, regardless of other
> >> matters.
> > 
> > Yep. The particular issue is https://lkml.org/lkml/2011/10/13/532
> > 
> > Li Zefan proposed a fix (https://lkml.org/lkml/2011/10/17/26) which I'm
> > currently reworking.
> > 
> 
> We really need to coordinate cgroup patches. I mean, the patchset+fix conflict
> with Tejun's work, and the conflict is not trivial.

Either Tejun targets for -mm, or I try to get my patches into the pm
tree where Tejun's patches are aimed. I just would like to keep Andrew
in the process of my patches somehow.

Also it might be time for you and/or Paul Menage to run a cgroup git tree, what do
you think :)

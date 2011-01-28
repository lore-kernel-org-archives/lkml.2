Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1A1PqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1A1PqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:46:10 -0500
Date: Fri, 28 Jan 2011 15:45:51 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
Message-ID: <20110128154551.GM26309@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
 <20110126161837.43830756.akpm@linux-foundation.org>
 <4D40C5A3.4070703@cn.fujitsu.com>
 <20110126174513.c2a20fff.akpm@linux-foundation.org>
 <4D4131DE.3080309@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D4131DE.3080309@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 09:50:38AM +0100, Daniel Lezcano wrote:
> On 01/27/2011 02:45 AM, Andrew Morton wrote:
> >On Thu, 27 Jan 2011 09:08:51 +0800 Li Zefan<lizf@cn.fujitsu.com>  wrote:
> >
> >>Andrew Morton wrote:
> >>>On Tue, 25 Jan 2011 10:39:48 +0100
> >>>Daniel Lezcano<daniel.lezcano@free.fr>  wrote:
> >>>
> >>>>This patch removes the ns_cgroup as suggested in the following thread:
> >>>I had this patch queued up in September last year, but dropped it.  Why
> >>>did I do that?
> >>Because you wanted to wait for some time for users (if any) to notice this
> >>coming change.
> >>
> >>Author: Daniel Lezcano<daniel.lezcano@free.fr>
> >>Date:   Wed Oct 27 15:33:38 2010 -0700
> >>
> >>     cgroup: notify ns_cgroup deprecated
> >>
> >>     The ns_cgroup will be removed very soon.  Let's warn, for this version,
> >>     ns_cgroup is deprecated.
> >>
> >>     Make ns_cgroup and clone_children exclusive.  If the clone_children is set
> >>     and the ns_cgroup is mounted, let's fail with EINVAL when the ns_cgroup
> >>     subsys is created (a printk will help the user to understand why the
> >>     creation fails).
> >>
> >>     Update the feature remove schedule file with the deprecated ns_cgroup.
> >>
> >>     Signed-off-by: Daniel Lezcano<daniel.lezcano@free.fr>
> >>     Acked-by: Paul Menage<menage@google.com>
> >>     Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> >>     Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> >ooh, that was clever of me.
> >
> >Here is the text which was missing from the changelog:
> >
> >   This is a userspace-visible change.  Commit 45531757b45c ("cgroup:
> >   notify ns_cgroup deprecated") (merged into 2.6.27) caused the kernel
> >   to emit a printk warning users that the feature is planned for
> >   removal.  Since that time we have heard from XXX users who were
> >   affected by this.
> >
> >Please provide XXX.
> 
> Ok, AFAIK nobody makes use of the ns_cgroup except the LXC userspace
> tools which I maintain and where
> the backward compatibility with the ns_cgroup and the clone_children
> flag is already implemented.
> Since today nobody seems to be affected by this.
> 
> I Cc'ed the libvirt mailing list.

Removing 'ns_cgroup' won't impact libvirt's container
support in any negative way, so fine by me.

Regards,
Daniel

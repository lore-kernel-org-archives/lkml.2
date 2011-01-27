Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1A0Bpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:45:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1A0Bpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:45:51 -0500
Date: Wed, 26 Jan 2011 17:45:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
Message-Id: <20110126174513.c2a20fff.akpm@linux-foundation.org>
In-Reply-To: <4D40C5A3.4070703@cn.fujitsu.com>
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
	<20110126161837.43830756.akpm@linux-foundation.org>
	<4D40C5A3.4070703@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 09:08:51 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Andrew Morton wrote:
> > On Tue, 25 Jan 2011 10:39:48 +0100
> > Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> > 
> >> This patch removes the ns_cgroup as suggested in the following thread:
> > 
> > I had this patch queued up in September last year, but dropped it.  Why
> > did I do that?
> 
> Because you wanted to wait for some time for users (if any) to notice this
> coming change.
> 
> Author: Daniel Lezcano <daniel.lezcano@free.fr>
> Date:   Wed Oct 27 15:33:38 2010 -0700
> 
>     cgroup: notify ns_cgroup deprecated
>     
>     The ns_cgroup will be removed very soon.  Let's warn, for this version,
>     ns_cgroup is deprecated.
>     
>     Make ns_cgroup and clone_children exclusive.  If the clone_children is set
>     and the ns_cgroup is mounted, let's fail with EINVAL when the ns_cgroup
>     subsys is created (a printk will help the user to understand why the
>     creation fails).
>     
>     Update the feature remove schedule file with the deprecated ns_cgroup.
>     
>     Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
>     Acked-by: Paul Menage <menage@google.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

ooh, that was clever of me.

Here is the text which was missing from the changelog:

  This is a userspace-visible change.  Commit 45531757b45c ("cgroup:
  notify ns_cgroup deprecated") (merged into 2.6.27) caused the kernel
  to emit a printk warning users that the feature is planned for
  removal.  Since that time we have heard from XXX users who were
  affected by this.

Please provide XXX.

How do we know that 2.6.37->2.6.38 is long enough?  Will any major
distros be released containing this warning in that timeframe?  I doubt
it.


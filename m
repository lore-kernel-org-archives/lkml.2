Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2AZJmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:42:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2AZJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:42:43 -0500
Date: Thu, 26 Jan 2012 01:48:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: Linux 3.3-1 out - merge window closed
Message-Id: <20120126014836.aaf79457.akpm@linux-foundation.org>
In-Reply-To: <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
	<20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 15:14:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Thu, 19 Jan 2012 15:58:28 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > (Stats for those that like them: 20% arch updates (arm, power, mips,
> > x86), 60% drivers (networking - wireless in particular, staging,
> > media, dri, sound, misc - including getting rid of 'struct sysdev'),
> > and 20% random stuff: filesystems, networking, perf etc)
> 
> More stats for the bored:
> 
> (I don't count merge commits below and everything is relative to v3.2)
> 
> Of the 8899 commits in v3.3-rc1, 6918 were in next-20120106 (the first
> -next based on v3.2).  A further 792 commits have the same subject line as
> commits in next-20120116 and a further 16 have the same patch-id.
> 
> This leaves 1174 commits (13%) in v3.3-rc1 that were not in next-20120106
> for some reason (not too bad really, I guess).

That's a lot.  Please name names!

I was impacted by several busted patches which had not appeared in
-next.

Also, I saw numerous patches which were significantly altered during
their trip from -next to mainline, which is cheating.  These showed up
as a massive reject storm when I attempted to git-merge linus-now with
next-from-12-hours-ago.  I went in and checked.  tools/perf was a major
culprit.

> Some will clearly be bug
> fixes, of course.  Some will be quilt trees (probably rebased before
> being sent to Linus).  Some will be patches that depend on work by others.

The quilt trees would have been eliminated by the "commits have the
same subject line" test?


I don't think this is all a huuuge problem - we sort this stuff out
fairly quickly.  But things could be improved a bit.

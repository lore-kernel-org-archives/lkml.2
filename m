Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2LJSMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:12:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40844 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2LJSMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:12:54 -0500
Date: Mon, 10 Dec 2012 10:12:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing tags in my local stable git repo
Message-ID: <20121210181250.GC30847@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355160900.17101.229.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:35:00PM -0500, Steven Rostedt wrote:
> Hi Greg,
> 
> I'm curious if you are removing tags from your git repo on kernel.org.

No, not at all, and I can see these tags in my repo, and in the one on
kernel.org.

> And the stable.git remotes look like:
> 
> origin  /home/rostedt/work/git/nobackup/linus.git/ (fetch)
> origin  /home/rostedt/work/git/nobackup/linus.git/ (push)
> stable  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git (fetch)
> stable  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git (push)

Can you see the tags here in your local copy of the linux-stable.git
tree?

> My linus.git tree is simply a bare tree that mirrors Linus's tree:
> 
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (fetch)
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (push)
> 
> I have a crontab that updates these every night with a 'git remote
> update' and once a week they do a 'git gc' on these repos. I notice the
> above issues after the git gc.
> 
> I'm not sure where the problem arised, but did you do any cleanups of
> tags on the stable git repo?

No I do not, so I don't know what is going on, sorry.

Try cloning the linux-stable.git tree from scratch to see if you still
have this issue.  Odds are, something with all of the alternates is
getting confused somewhere.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2LJTCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:02:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2LJTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:02:54 -0500
Date: Mon, 10 Dec 2012 11:02:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing tags in my local stable git repo
Message-ID: <20121210190247.GA32119@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
 <1355165264.17101.233.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355165264.17101.233.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 01:47:44PM -0500, Steven Rostedt wrote:
> On Mon, 2012-12-10 at 12:35 -0500, Steven Rostedt wrote:
> 
> > I have a crontab that updates these every night with a 'git remote
> > update' and once a week they do a 'git gc' on these repos. I notice the
> > above issues after the git gc.
> 
> Looking at my script that does the git gc, it runs:
> 
>  git gc --aggressive
> 
> on the stable.git tree. I wonder if that made a difference.

I think 'git gc' might have cause the problem, as it looks like it
pruned branches that you hadn't accessed in a long time, so it cleaned
them up.

greg k-h

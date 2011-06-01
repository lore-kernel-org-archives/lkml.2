Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1FAGWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:22:37 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56349 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506Ab1FAGWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:22:36 -0400
Date: Wed, 1 Jun 2011 06:22:25 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Turning off the incremental diff robot
Message-ID: <20110601062225.GA4705@localhost.ucw.cz>
References: <4DE3E9E7.8020008@zytor.com> <20110530194500.GE10792@home.goodmis.org> <4DE402BD.4060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE402BD.4060407@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-05-30 13:49:01, H. Peter Anvin wrote:
> On 05/30/2011 12:45 PM, Steven Rostedt wrote:
> > On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> >> Hi all,
> >>
> >> With the v3.0 name change I was looking over what might break, and I'm
> >> seriously considering turning off the incremental diff robot on
> >> kernel.org.  It's not clear to me that it is actually useful anymore,
> >> with git and all.
> > 
> > What is the incremental diff robot?
> > 
> > Does it make the patches between 2.6.x to 2.6.x+1?
> > 
> 
> No, but it generates the patches between, say, 2.6.x.y and 2.6.x.y+1 or
> 2.6.x-rcy and 2.6.x-rcy+1.  Anything in an "incr" directory.

-git1 to -git2 diffs are probably not useful.

2.6.39.1 to 2.6.39.2 diffs are useful IMO - people using stable
kernels do not use git.

I'm using -rc1 to -rc2 diffs. Useful :-).			Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1JKOVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:21:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1JKOVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:21:18 -0400
Date: Tue, 11 Oct 2011 08:20:06 -0600
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: Commits missed for stable
Message-ID: <20111011142006.GA18281@suse.de>
References: <1318337139.7904.170.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318337139.7904.170.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:45:38AM -0400, Steven Rostedt wrote:
> It's come to my attention that a bug that was fixed by:
> 
> 43dd61c9a09bd413e837df829e6bfb42159be52a
> ftrace: Fix regression of :mod:module function enabling
> 
> 
> Exists in the -rt kernel. As the -rt kernel is based off of 3.0.6, this
> means that the bug also exists in the stable tree. Without the fix, the
> kernel will crash if the root user tries to use the :mod: functionality
> of ftrace.
> 
> I also believe that the commit:
> 
> 
> f7bc8b61f65726ff98f52e286b28e294499d7a08
> ftrace: Fix regression where ftrace breaks when modules are loaded
> 
> is missing from both stable and -rt as well.
> 
> Greg, can you add the above two commits to the stable branch.

Both now queued up, thanks for letting me know.

greg k-h

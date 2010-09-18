Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab0ISEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:16:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0ISEQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:16:55 -0400
Date: Sat, 18 Sep 2010 15:19:56 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, stable-review@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [064/123] sched: Protect task->cpus_allowed
	access in sched_getaffinity()
Message-ID: <20100918221956.GA25060@suse.de>
References: <20100918185724.290702750@clark.site> <20100918185958.285024381@clark.site> <1284841948.5879.301.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284841948.5879.301.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 09:32:28PM +0100, Ben Hutchings wrote:
> I'm somewhat disturbed by the number of non-trivial scheduler changes
> here.  How well have these been tested as applied to the 2.6.32.y
> branch?

Mike has tested these very well and gotten the ACK for them to go in
from Ingo and Peter.

I think they are also currently shipping in one distro's enterprise
kernel as well, but am not quite sure...

Ben, feel free to test them yourself and report any problems, but at the
least, they do fix one reported problem, and lots of others as well.

thanks,

greg k-h

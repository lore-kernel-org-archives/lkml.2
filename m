Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0ISJkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:40:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0ISJkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:40:05 -0400
Subject: Re: [Stable-review] [064/123] sched: Protect task->cpus_allowed
 access in sched_getaffinity()
From: Mike Galbraith <mgalbraith@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <1284873006.7467.1.camel@marge.simson.net>
References: <20100918185724.290702750@clark.site>
	 <20100918185958.285024381@clark.site> <1284841948.5879.301.camel@localhost>
	 <1284873006.7467.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 19 Sep 2010 11:40:13 +0200
Message-Id: <1284889213.23005.80.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 07:10 +0200, Mike Galbraith wrote:
> On Sat, 2010-09-18 at 21:32 +0100, Ben Hutchings wrote:
> > I'm somewhat disturbed by the number of non-trivial scheduler changes
> > here.  How well have these been tested as applied to the 2.6.32.y
> > branch?
> 
> All of them of course.

(parse error)

The patch set saw a lot of stress and benchmark hours on boxen large and
small, to be as sure as anyone can be that it was not going to upset the
enterprise apple cart, nor harm the desktop.

I call it heavily tested, but can't post a detailed log of everything
done on every box for others to decide for themselves, since I didn't
compile same.

	-Mike


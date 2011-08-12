Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1HLSDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1HLSDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:03:42 -0400
Date: Fri, 12 Aug 2011 20:03:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [KTEST PATCH 00/10] collection of ktest patches
Message-ID: <20110812180336.GB18363@turtle.usersys.redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
 <1313171058.18583.347.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313171058.18583.347.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 01:44:18PM -0400, Steven Rostedt wrote:
> On Fri, 2011-08-12 at 15:32 +0200, Andrew Jones wrote:
> > More than once I've had to drive git-bisect to bisect boot issues for
> > Xen guests. The last time I needed to do so I decided to give ktest a
> > whirl. While whirling I wrote a couple patches and added a few features.
> > This patchset is the collection.
> 
> I do like your changes and I'll start queuing them up soon. Probably
> need to rename the PASS_COUNT though. What do you think of RERUN?

Thanks! I've sent the rerun patch.

> 
> Anyway, I only post to Linus during the merge window (except for bug
> fixes), which means they wont be in mainline until 3.2.
>

no problem
 
> The best thing about this patchset, is that it proves that ktest is used
> by more than 1 person. It's doubled its usage statistics!

lol

> 
> -- Steve
> 
> > 
> > Andrew Jones (10):
> >   ktest: create outputdir, if it doesn't exist
> >   ktest: small cleanup
> >   ktest: factor reboot code
> >   ktest: Introduce RESET_TIME
> >   ktest: refactor monitor/boot/test code
> >   ktest: make start_monitor_and_boot true to its name
> >   ktest: Introduce PASS_COUNT
> >   ktest: test faster, put REBOOT_ON_SUCCESS to more work
> >   ktest: test faster, favor rsync over the tarball method
> >   ktest: Introduce FAILURE_LINE
> > 
> >  tools/testing/ktest/ktest.pl    |  208 +++++++++++++++++++++++----------------
> >  tools/testing/ktest/sample.conf |   23 ++++-
> >  2 files changed, 147 insertions(+), 84 deletions(-)
> > 
> 
> 

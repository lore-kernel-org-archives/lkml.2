Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2EKPzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:55:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57473 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903Ab2EKPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:55:50 -0400
Date: Fri, 11 May 2012 10:55:49 -0500
From: Robin Holt <holt@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
Message-ID: <20120511155549.GI3751@sgi.com>
References: <20120511133938.GG3751@sgi.com>
 <1336746790.1017.17.camel@twins>
 <20120511150533.GH3751@sgi.com>
 <1336750573.1017.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336750573.1017.25.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 05:36:13PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-11 at 10:05 -0500, Robin Holt wrote:
> > On Fri, May 11, 2012 at 04:33:10PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2012-05-11 at 08:39 -0500, Robin Holt wrote:
> > > 
> > > > We found that reverting the commit:
> > > > cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support
> > > > 
> > > > also got things working.
> > > 
> > > there's a particularly stupid bug in that code
> > 
> > Even with that applied, I still get the divide by zero.
> 
> Humm.. what kind of machine is this? And how far along does it get in
> booting? ->power isn't supposed to get to 0.

It is a four blade (8 socket 80 core 160 hyper-thread machine) with 40
GB of RAM.

Looking at the earlier kernel messages, I am wondering if I don't have a
BIOS that is giving me crud.  I have messages about hyperthreads being
on different nodes.  That had not been happening in the past.  I don't
have access to the machine now, but the BIOS string that had printed
out is from a developer's debug version.

When I get access to the machine again (likely not until Monday), I
will flash a release BIOS and retest.  Until then, please feel free to
ignore me.

Thanks,
Robin

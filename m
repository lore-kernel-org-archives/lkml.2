Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0EaHys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:54:48 -0400
Received: from ozlabs.org ([203.10.76.45]:46602 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0EaHyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:54:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Mon, 31 May 2010 17:24:44 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <201005271456.20003.rusty@rustcorp.com.au> <201005272357.28141.rjw@sisk.pl>
In-Reply-To: <201005272357.28141.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311724.45465.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 07:27:28 am Rafael J. Wysocki wrote:
> On Thursday 27 May 2010, Rusty Russell wrote:
> > On Thu, 27 May 2010 08:26:25 am Rafael J. Wysocki wrote:
> > > On Wednesday 26 May 2010, Rusty Russell wrote:
> > > > I suspect that the increased parallelism enabled by this patch uncovered this
> > > > bug.  Does this fix it?
> > > 
> > > Since the commit has been reverted, do you still want me to test this patch?
> > > Quite frankly I'd prefer to test a complete replacement for that commit on top
> > > of current -git.
> > 
> > OK, combo meal deal below, against Linus' latest.  I'd really appreciate
> > a report, since AFAIK you're the only one hitting it, and only when that
> > other (now reverted) patch was applied.
> 
> I cannot reproduce the crash with the patch below.
> 
> Thanks,
> Rafael

Great, thanks for testing!  Though the patch which uncovered this has been
reverted, it could still bite someone.

Linus, I'll send the fix separately, then rework the other fix with clearer
locking and more love for the kprobes guys...

Thanks,
Rusty.

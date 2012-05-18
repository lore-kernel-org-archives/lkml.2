Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966702Ab2ERMAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:00:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56085 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966331Ab2ERMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:00:03 -0400
Date: Fri, 18 May 2012 13:59:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518115957.GB19785@gmail.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337336040.573.12.camel@twins>
 <20120518110357.GH20215@aftab.osrc.amd.com>
 <1337340263.573.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337340263.573.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2012-05-18 at 13:03 +0200, Borislav Petkov wrote:
> > >  - you allow an arbitrary place in debugfs; this might make finding
> > > them 'interesting'. Should we put them all in the same place?
> > 
> > My take on this is that we want to be able to make the same events we
> > have now, persistent. Basically not trace for the duration of a child
> > process but in a process-agnostic way, system-wide.
> 
> This would argue against per-task persistent events.. 

Yeah, 'persistency' is something that's per CPU at minimum.

> Note the plural there, it might be very desirable to allow 
> multiple events into a single persistent buffer.

very, very, very much so. One (per CPU) buffer, with many events 
multiplexed into it.

Thanks,

	Ingo

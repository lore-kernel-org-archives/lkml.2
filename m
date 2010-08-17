Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0HQLwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:52:54 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:54423 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981Ab0HQLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:52:53 -0400
Date: Tue, 17 Aug 2010 21:52:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
Message-ID: <20100817115243.GE7362@dastard>
References: <20100817073725.GO10429@dastard>
 <4C6A4A58.2030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6A4A58.2030904@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 04:37:44PM +0800, Lai Jiangshan wrote:
> On 08/17/2010 03:37 PM, Dave Chinner wrote:
> > Tracing folks,
> > 
> > I've got a machine stuck with a cpu spinning in a tight loop (the
> > new writeback/sync livelock avoidance code is, well, livelocking),
> > and I was trying to find out what triggered by using the writeback
> > trace events. Unfortunately, I can't dump the trace events because
> > it gets stuck here:
> 
> > 
> > Given that the trace events are there mainly for debugging, this
> > seems like a bit of an oversight - hanging a CPU in a tight loop is
> > not an uncommon event during code development....
> > 
> 
> You can try 'cat trace_pipe', if I did not miss you meaning.

I'll try it, but I'm really after the static event list which is why
I'm using the trace file rather than trace_pipe. I want the history,
not new events as they happen. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

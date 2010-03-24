Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0CXAbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:31:12 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60183 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0CXAbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dcYVen1Xv4Ncnzl37MDXDJy4zXchoRyWHjd3byKYUQKyGL4v9rS6W/eGo5whVrjPHa
         kJPmOxkyscV4l9udJhryz0+psABpu6zhmpdwiwQ3iFQoFQ1APapBP+NxHyAObQClYoLX
         xT3aFZXj2QBLrQMD10NwUawK5two4oLyeqOd8=
Date: Wed, 24 Mar 2010 01:31:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/18] sched: Generate trace points only if scheduler
	tracing is enabled
Message-ID: <20100324003106.GA9425@nowhere>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <1269304340-25372-7-git-send-email-jack@suse.cz> <20100323010756.GB8292@nowhere> <1269388321.5363.377.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269388321.5363.377.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 07:52:01PM -0400, Steven Rostedt wrote:
> On Tue, 2010-03-23 at 02:07 +0100, Frederic Weisbecker wrote:
> > On Tue, Mar 23, 2010 at 01:32:08AM +0100, Jan Kara wrote:
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > CC: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > 
> > 
> > Note this one is an exception.
> > Once tracing is enabled, we need the context switch
> > tracer anyway to keep track of the pid:cmdline mappings.
> > 
> > 
> 
> Yes, the scheduling tracepoints are needed by several tracers. This must
> be enabled by all.
> 
> But then again, I'm thinking it would be nicer to find a way to lower
> the impact than just turning them off.
> 
> Perhaps only allow the individual disabling if CONFIG_EMBEDDED is set.


Yeah agreed!


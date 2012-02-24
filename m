Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2BXQ1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2BXQ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:27:50 -0500
Date: Fri, 24 Feb 2012 11:27:46 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120224162745.GC13903@zod.bos.redhat.com>
References: <20120222011652.GE23186@zod.bos.redhat.com>
 <20120222013252.GZ2375@linux.vnet.ibm.com>
 <20120222014242.GF23186@zod.bos.redhat.com>
 <20120224144032.GA13903@zod.bos.redhat.com>
 <20120224161743.GA2399@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224161743.GA2399@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 08:17:43AM -0800, Paul E. McKenney wrote:
> On Fri, Feb 24, 2012 at 09:40:32AM -0500, Josh Boyer wrote:
> > On Tue, Feb 21, 2012 at 08:42:43PM -0500, Josh Boyer wrote:
> > > > And patch #47 in that series has been obsoleted by another series
> > > > from Steven Rostedt:
> > > > 
> > > > 	https://lkml.org/lkml/2012/2/7/231
> > > 
> > > Ok.
> > > 
> > > > Hopefully these fix both splats and slowness.
> > > 
> > > So again, I'm slightly confused on how RCU patches flow.  Eric
> > > originally reported the bug for which you created the patch I applied
> > > against 3.3.  The giant patch series above seems queued for 3.4.
> > > 
> > > I don't see stable CC'd on 45-47, nor any of Steven's patches.  I doubt
> > > I'd want to go applying the 47-patch series on 3.3 at the moment, and
> > > given you have these marked for 3.4 I don't think you do either.
> > > However, is there some kind of fix for the original bug report against
> > > 3.3?
> > 
> > I was being sincere when I asked the above questions.  Could you
> > describe how you handle RCU patches across releases and if there is a
> > fix for the 3.3-rcX issue Eric reported that is going into 3.3?
> > 
> > I know you're quite busy, but I'd like to understand your thinking so I
> > know what to expect going forward.
> 
> Apologies for being slow, but could you please point me at the original
> bug report that the old patch was designed to fix?  My email filing
> seems to have failed me in this case.

Same thread I linked in my original email:

https://lkml.org/lkml/2012/1/24/203

> My guess is that the best short-term fix for Fedora is to disable the
> warning, but I do need to see the original bug to work out if that really
> is a prudent course of action.

Honestly, I don't care from a Fedora perspective.  I can do what I need
to do there without too much trouble.  I'm asking because afaik, upstream
still has this problem.  The thread gets a bit curvy but from what I can
tell it resulted in the patch I highlighted as having issues.  Maybe I
overlooked something else that fixed Eric's problem?

josh

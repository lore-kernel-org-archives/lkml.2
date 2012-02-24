Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2BXQS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:18:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44715 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BXQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:18:28 -0500
Date: Fri, 24 Feb 2012 08:17:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120224161743.GA2399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120222011652.GE23186@zod.bos.redhat.com>
 <20120222013252.GZ2375@linux.vnet.ibm.com>
 <20120222014242.GF23186@zod.bos.redhat.com>
 <20120224144032.GA13903@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224144032.GA13903@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022416-2398-0000-0000-000004820135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:40:32AM -0500, Josh Boyer wrote:
> On Tue, Feb 21, 2012 at 08:42:43PM -0500, Josh Boyer wrote:
> > > And patch #47 in that series has been obsoleted by another series
> > > from Steven Rostedt:
> > > 
> > > 	https://lkml.org/lkml/2012/2/7/231
> > 
> > Ok.
> > 
> > > Hopefully these fix both splats and slowness.
> > 
> > So again, I'm slightly confused on how RCU patches flow.  Eric
> > originally reported the bug for which you created the patch I applied
> > against 3.3.  The giant patch series above seems queued for 3.4.
> > 
> > I don't see stable CC'd on 45-47, nor any of Steven's patches.  I doubt
> > I'd want to go applying the 47-patch series on 3.3 at the moment, and
> > given you have these marked for 3.4 I don't think you do either.
> > However, is there some kind of fix for the original bug report against
> > 3.3?
> 
> I was being sincere when I asked the above questions.  Could you
> describe how you handle RCU patches across releases and if there is a
> fix for the 3.3-rcX issue Eric reported that is going into 3.3?
> 
> I know you're quite busy, but I'd like to understand your thinking so I
> know what to expect going forward.

Apologies for being slow, but could you please point me at the original
bug report that the old patch was designed to fix?  My email filing
seems to have failed me in this case.

My guess is that the best short-term fix for Fedora is to disable the
warning, but I do need to see the original bug to work out if that really
is a prudent course of action.

							Thanx, Paul


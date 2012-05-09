Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab2EIRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:49:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54024 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2EIRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:48:58 -0400
Date: Wed, 9 May 2012 10:48:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120509174853.GF24636@google.com>
References: <20120509174114.GE24636@google.com>
 <Pine.LNX.4.44L0.1205091346070.1658-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205091346070.1658-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 01:47:34PM -0400, Alan Stern wrote:
> On Wed, 9 May 2012, Tejun Heo wrote:
> 
> > Hello,
> > 
> > On Tue, May 08, 2012 at 02:53:11PM -0400, Alan Stern wrote:
> > > On Mon, 7 May 2012, Tejun Heo wrote:
> > > 
> > > > On Mon, May 07, 2012 at 05:51:52PM -0400, Alan Stern wrote:
> > > > > I guess in the end it's a question of balance.  Which has more 
> > > > > overhead, adding a few function calls here and there, or adding a new 
> > > > > flags field to every struct attribute?
> > > > 
> > > > Yes, and there are different types of overheads.  I'm happy to trade
> > > > some runtime memory overhead under debugging mode for lower code
> > > > complexity.  Lock proving is pretty expensive anyway.  I don't think
> > > > there's much point in trying to optimize some bytes from struct
> > > > attributes.
> > > 
> > > Okay, then what do you think about this approach?  It does seem smaller 
> > > and simpler than the previous attempt.
> > > 
> > > And I did try to avoid unnecessary bloat; if lockdep isn't being used
> > > then the extra attribute flag isn't present.
> > 
> > Yeap, looks good to me.
> 
> Unless there are any objections from Eric or Peter in the next few
> days, I'll submit it.  Can I add your Acked-by?

Sure.

Thanks for the persistence.

-- 
tejun

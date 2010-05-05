Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0EEUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:09:19 -0400
Received: from mga12.intel.com ([143.182.124.36]:63527 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755638Ab0EEUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,335,1270450800"; 
   d="scan'208";a="273749477"
Date: Wed, 5 May 2010 13:09:06 -0700
From: mark gross <mgross@linux.intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100505200906.GA7450@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20100504160346.GA27938@linux.intel.com>
 <Pine.LNX.4.44L0.1005041252480.1729-100000@iolanthe.rowland.org>
 <20100505015050.GA30591@linux.intel.com>
 <20100505133131.GA24477@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505133131.GA24477@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:31:31PM +0100, Matthew Garrett wrote:
> On Tue, May 04, 2010 at 06:50:50PM -0700, mark gross wrote:
> 
> > In my sequence above I had the modem driver "magically" knowing to fail
> > this suspend attempt.  (that "magic" wasn't fully thought out though.)
> 
> If the modem driver knows to "magically" fail a suspend attempt until it 
> knows that userspace has consumed the event, you have something that 
> looks awfully like suspend blockers.
> 
> > There *has* to be a better way.
> 
> But nobody has reasonably proposed one and demonstrated that it works. 
> We've had over a year to do so and failed, and I think it's pretty 
> unreasonable to ask Google to attempt to rearchitect based on a 
> hypothetical.
>

These are not new issues being raised. They've had over a year to
address them, and all thats really happened was some sed script changes
from wake_lock to suspend_blocker.  Nothing is really different
here.

Rearchitecting out of tree code is as silly thing for you to expect from
a community member.  

sigh, lets stop wasting time and just merge it then.

I'm finished with this thread until I do some rearchecting and post
something that looks better to me.  I'll look for this stuff in 2.6.34
or 35.

--mgross 
ps It think the name suspend blocker is worse than wake-lock.  I'd
change it back.



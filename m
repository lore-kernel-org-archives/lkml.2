Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485Ab2COOgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761209Ab2COOg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:36:29 -0400
Date: Thu, 15 Mar 2012 10:35:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315143549.GC3941@redhat.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
 <20120315014511.GT27051@google.com>
 <1331809239.18960.168.camel@twins>
 <1331809597.18960.171.camel@twins>
 <20120315124228.GA5318@elte.hu>
 <1331820051.18960.187.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331820051.18960.187.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 03:00:51PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-15 at 13:42 +0100, Ingo Molnar wrote:
> > So unless there's concensus to remove everything but the hard 
> > lockup detection facilities, lets solve the technical problem at 
> > hand, ok? 
> 
> Well, at least make it possible to disable the silly soft thing.
> 
> And I really wouldn't know how the soft thing could possible help,
> except when not actually having a NMI watchdog. What case does it
> trigger where the NMI one doesn't?

I think softlockup really boils down to a pre-emption disabled detector
much like how the hardlockup really is a interrupts disabled detector.

The amount of code preventing the scheduler from running is most likely a
lot lower than the code the prevents interrrupts from happening.

Cheers,
Don


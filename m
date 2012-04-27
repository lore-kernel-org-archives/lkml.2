Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab2D0URL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:17:11 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60810 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2D0URI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:17:08 -0400
Date: Fri, 27 Apr 2012 13:17:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120427201704.GK26595@google.com>
References: <87haw55eed.fsf@xmission.com>
 <Pine.LNX.4.44L0.1204271410470.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204271410470.1690-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:27:26PM -0400, Alan Stern wrote:
> Which do you prefer: temporarily dropping the lockdep annotation, or
> deferring the work to the per-task work queue?  Note that these "flush
> before returning to userspace" things aren't in the kernel yet.

It's about lockdep.  Let's not spill out to other areas unnecessarily.
I'd much prefer just working around lockdep annotation.

Thanks.

-- 
tejun

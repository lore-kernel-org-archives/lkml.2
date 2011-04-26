Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1DZN2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:28:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1DZN2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:28:14 -0400
Date: Tue, 26 Apr 2011 06:17:37 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device
 PM.
Message-ID: <20110426131737.GA13597@suse.de>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
 <201104261347.21811.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104261347.21811.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 01:47:21PM +0200, Rafael J. Wysocki wrote:
> Moreover, I'm not sure if kernel subsystems (including drivers) should really
> decide when to generate wakeup signals in the first place.  Generally,
> user space decides what devices should wake up the system from sleep and the
> kernel should follow.  So, there shouldn't be any wakeup signals enabled
> beyond what user space has requested.

The RTC wakeup signals are ok though, right?  Userspace is the one
asking for that from what I can tell.

> To conclude, I'm not sure about the approach.  In particular, I'm not sure
> if the benefit is worth the effort and the resulting complications (ie. the
> possibility of having to deal with wakeup signals not requested by user
> space) seem to be a bit too far reaching.
> 
> Greg, what do you think?

I agree with you in that I don't think that this type of feature is
valid at the moment.

I don't understand why our current situation doesn't work, what are we
lacking that is needed for these systems that we have not seen before?

What is the root problem that this is trying to solve?

thanks,

greg k-h

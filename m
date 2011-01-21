Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1AUVUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:20:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45668 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1AUVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:20:34 -0500
Date: Fri, 21 Jan 2011 21:20:28 +0000
From: James Hogan <james@albanarts.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.38-rc1 resume hang (da8aeb92 "ACPI/Battery: Update
 information on info notification and resume")
Message-ID: <20110121212028.GA2916@gandalf>
References: <20110121140031.GA3280@gandalf>
 <201101212130.26693.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101212130.26693.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Jan 21, 2011 at 09:30:26PM +0100, Rafael J. Wysocki wrote:
> On Friday, January 21, 2011, James Hogan wrote:
> > Hi,
> > 
> > After updating from 2.6.37 to 2.6.28-rc1, resume from suspend is broken
> > on my Dell M1210 Laptop.
> > 
> > I tried pm_trace and both block and battery matched the hash, so I
> > bisected the problem to commit da8aeb92 (see below).
> > 
> > I've reverted this commit on 2.6.38 and it doesn't die on resume anymore.
> > 
> > My bisection log and .config are pasted below.
> > 
> > Let me know if I can provide any more info or help test any patches etc.
> 
> This should have been fixed already in the current Linus' tree by this commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b23fffd778c312b8fb258d342051fcbdf6712128
> 
> Can you verify, please?

Yes, that fixes it. I'll remember to check for an existing fix at the
end of the bisection as well as the beginning next time.

Thanks

James

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1LELDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:03:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43324 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1LELDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:03:46 -0500
Date: Mon, 5 Dec 2011 12:03:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
Message-ID: <20111205110336.GA13546@elf.ucw.cz>
References: <1322847694.30977.45.camel@frodo>
 <Pine.LNX.4.44L0.1112021655580.1452-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112021655580.1452-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-12-02 16:57:06, Alan Stern wrote:
> On Fri, 2 Dec 2011, Steven Rostedt wrote:
> 
> > On Fri, 2011-12-02 at 11:23 -0500, Alan Stern wrote:
> > 
> > > Take a look at the two files
> > > 
> > > 	/sys/bus/pci/devices/0000:00:1[ad].0/power/wakeup
> > > 
> > > If they contain the word "enabled", write "disabled" to them.  See 
> > > Documentation/ABI/testing/sysfs-devices-power.
> > 
> > The files do exist, but they are already set to "disabled".
> 
> Bummer.  This sounds like something for the ACPI/BIOS people to work 
> on...

Is "USB legacy emulation" enabled in the BIOS? That caused problems
before...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

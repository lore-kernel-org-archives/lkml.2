Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1LDQyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:54:47 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53444 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751508Ab1LDQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:54:45 -0500
Date: Sun, 4 Dec 2011 11:54:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
In-Reply-To: <20111203202330.GA21011@ellpspace.math.ualberta.ca>
Message-ID: <Pine.LNX.4.44L0.1112041128580.32730-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Dec 2011, Michal Jaegermann wrote:

> On Sat, Dec 03, 2011 at 10:19:27AM -0500, Alan Stern wrote:
> > On Fri, 2 Dec 2011, Michal Jaegermann wrote:
> > > 
> > > On my ASUS K52Jc these controllers are also reported "disabled".  This
> > 
> > What exactly do you mean by that?
> 
> I mean that you asked Steven about a content of
> /sys/bus/pci/devices/0000\:00\:1[ad].0/power/wakeup
> On my ASUS K52Jc these ids also happen to belong to ehci_hcd devices
> (both "Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host
> Controller") and both 'wakeup' files show "disabled" too.

Oh, sorry -- I didn't realize you meant the power/wakeup file contained 
"disabled".  It sounded like you were saying that the controllers were 
somehow disabled.

> With that above I have to do all these manipulations with unbinding
> and binding drivers and removing inserting modules or a laptop will hang
> after a suspend.  Now with a recent kernel I need additionally put
> wireless driver modules on a "special handling" list or I will loose
> such connection (no hang here, just a dead driver).
> 
> All of this looks like pretty consistent, from what one can find on the
> net, across various models of ASUS laptops.

Yes, apparently ASUS's recent chipsets or firmware has a problem with
suspend and resume.  On the other hand, I'm writing this on an ASUS
UL20A laptop, which suspends and resumes with no difficulty.

Alan Stern


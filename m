Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1LCUXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 15:23:49 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:52674 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321Ab1LCUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 15:23:48 -0500
Date: Sat, 3 Dec 2011 13:23:30 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
Message-ID: <20111203202330.GA21011@ellpspace.math.ualberta.ca>
References: <20111203024317.GA5370@ellpspace.math.ualberta.ca>
 <Pine.LNX.4.44L0.1112031018530.16284-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112031018530.16284-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 10:19:27AM -0500, Alan Stern wrote:
> On Fri, 2 Dec 2011, Michal Jaegermann wrote:
> > 
> > On my ASUS K52Jc these controllers are also reported "disabled".  This
> 
> What exactly do you mean by that?

I mean that you asked Steven about a content of
/sys/bus/pci/devices/0000\:00\:1[ad].0/power/wakeup
On my ASUS K52Jc these ids also happen to belong to ehci_hcd devices
(both "Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host
Controller") and both 'wakeup' files show "disabled" too.

With that above I have to do all these manipulations with unbinding
and binding drivers and removing inserting modules or a laptop will hang
after a suspend.  Now with a recent kernel I need additionally put
wireless driver modules on a "special handling" list or I will loose
such connection (no hang here, just a dead driver).

All of this looks like pretty consistent, from what one can find on the
net, across various models of ASUS laptops.

   Michal

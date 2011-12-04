Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1LDTyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:54:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab1LDTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:54:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspend and resume on ASUS Laptops
Date: Sun, 4 Dec 2011 20:57:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <Pine.LNX.4.44L0.1112041128580.32730-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112041128580.32730-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112042057.11175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 04, 2011, Alan Stern wrote:
> On Sat, 3 Dec 2011, Michal Jaegermann wrote:
> 
> > On Sat, Dec 03, 2011 at 10:19:27AM -0500, Alan Stern wrote:
> > > On Fri, 2 Dec 2011, Michal Jaegermann wrote:
> > > > 
> > > > On my ASUS K52Jc these controllers are also reported "disabled".  This
> > > 
> > > What exactly do you mean by that?
> > 
> > I mean that you asked Steven about a content of
> > /sys/bus/pci/devices/0000\:00\:1[ad].0/power/wakeup
> > On my ASUS K52Jc these ids also happen to belong to ehci_hcd devices
> > (both "Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host
> > Controller") and both 'wakeup' files show "disabled" too.
> 
> Oh, sorry -- I didn't realize you meant the power/wakeup file contained 
> "disabled".  It sounded like you were saying that the controllers were 
> somehow disabled.
> 
> > With that above I have to do all these manipulations with unbinding
> > and binding drivers and removing inserting modules or a laptop will hang
> > after a suspend.  Now with a recent kernel I need additionally put
> > wireless driver modules on a "special handling" list or I will loose
> > such connection (no hang here, just a dead driver).
> > 
> > All of this looks like pretty consistent, from what one can find on the
> > net, across various models of ASUS laptops.
> 
> Yes, apparently ASUS's recent chipsets or firmware has a problem with
> suspend and resume.  On the other hand, I'm writing this on an ASUS
> UL20A laptop, which suspends and resumes with no difficulty.

I wonder, though, who figured out what quirk to use before suspend on those
particular machines and on what basis (some information from the vendor or
what?).

Thanks,
Rafael

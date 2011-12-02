Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1LBV5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:57:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35246 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755685Ab1LBV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:57:07 -0500
Date: Fri, 2 Dec 2011 16:57:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
In-Reply-To: <1322847694.30977.45.camel@frodo>
Message-ID: <Pine.LNX.4.44L0.1112021655580.1452-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Steven Rostedt wrote:

> On Fri, 2011-12-02 at 11:23 -0500, Alan Stern wrote:
> 
> > Take a look at the two files
> > 
> > 	/sys/bus/pci/devices/0000:00:1[ad].0/power/wakeup
> > 
> > If they contain the word "enabled", write "disabled" to them.  See 
> > Documentation/ABI/testing/sysfs-devices-power.
> 
> The files do exist, but they are already set to "disabled".

Bummer.  This sounds like something for the ACPI/BIOS people to work 
on...

Alan Stern


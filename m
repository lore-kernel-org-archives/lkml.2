Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1LCPTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 10:19:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40703 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752123Ab1LCPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 10:19:28 -0500
Date: Sat, 3 Dec 2011 10:19:27 -0500 (EST)
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
In-Reply-To: <20111203024317.GA5370@ellpspace.math.ualberta.ca>
Message-ID: <Pine.LNX.4.44L0.1112031018530.16284-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Michal Jaegermann wrote:

> On Fri, Dec 02, 2011 at 10:43:30AM -0500, Alan Stern wrote:
> > 
> > It's possible that this problem is related to wakeup settings.  Have 
> > you tried disabling wakeup for the EHCI controllers?
> 
> On my ASUS K52Jc these controllers are also reported "disabled".  This

What exactly do you mean by that?

> is after switching to Fedora 16 with its 3.1.2-1 kernel.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1LBEnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 23:43:09 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:52386 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333Ab1LBEnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 23:43:08 -0500
X-Greylist: delayed 2278 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 23:43:07 EST
Date: Thu, 1 Dec 2011 21:04:47 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oneukum@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspend and resume on ASUS Laptops
Message-ID: <20111202040447.GA16824@ellpspace.math.ualberta.ca>
References: <1322712689.30977.11.camel@frodo>
 <201112011035.57666.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112011035.57666.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 10:35:57AM +0100, Rafael J. Wysocki wrote:
> On Thursday, December 01, 2011, Steven Rostedt wrote:
> > For Black Friday I bought myself a ASUS-U56E-RBL8 at Staples for a
> > decent price. I installed Linux on it but it would not suspend.
.....
> > 
> > It just seems crazy to have everyday users add this script.
> 
> I totally agree, I had no idea it was necessary.

On  2011-04-16 I filed a pretty similar bug report in Red Hat bugzilla.
It sits here: https://bugzilla.redhat.com/show_bug.cgi?id=697150
still as ASSIGNED.  A kernel was based on 2.6.35 running on Asus K52Jc
but the problem really looks the same.  Assorted additional information
is attached to that bugzilla entry.  There is also
https://bugzilla.redhat.com/show_bug.cgi?id=675564

After all modifications described in my report, which included adding a line
SUSPEND_MODULES="xhci_hcd sdhci_pci sdhci"
in /etc/pm/config.d/hci.cfg I never had suspend/hibernate issues
again.  As a matter of fact I forgot about the problem. :-)

  Michal

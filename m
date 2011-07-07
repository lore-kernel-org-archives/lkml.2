Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1GGV47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:56:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57028 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1GGV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:56:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 7 Jul 2011 23:56:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0-rc6: USB khubd deadlock when hub is powered down
Message-ID: <20110707235647.13264b8a@stein>
In-Reply-To: <20110707204203.GA13931@xanatos>
References: <20110707100501.68a21fb8@stein>
	<20110707152958.42c88aec@stein>
	<20110707153849.51691bc4@stein>
	<20110707141022.GC27648@kroah.com>
	<20110707212449.261ffa78@stein>
	<20110707204203.GA13931@xanatos>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 07 Sarah Sharp wrote:
> On Thu, Jul 07, 2011 at 09:24:49PM +0200, Stefan Richter wrote:
> > On Jul 07 Greg KH wrote:
> > > Can you test Linus's tree, along with a patch sent yesterday from Alan
> > > Stern to the linux-usb mailing list (attached below)?  That should
> > > resolve this issue, if not, please let us know.
> > 
> > OK.  I am using 3.0-rc6-71-g4dd1b49 plus Alan's "USB: additional
> > regression fix for device removal" now.  So far it survived a dozen of
> > power toggles of the hub and the attached devices.  Thanks.
> > 
> > Alan Stern wrote:
> > > Still, we need to rewrite this stuff.  A possible race remains,
> > 
> > On a general level, the last few kernel.org releases have all been rather
> > weak.  Dissatisfied,
> 
> For USB regressions or the kernel overall?

Kernel overall.  USB unplug issues have been there before, but not as
reproducible as this one now.  (Which is apparently fixed for me now.)

I felt compelled to comment on Alan's sentence though because this does
not sound like the 2.6 development approach at all.  (Some other
subsystem projects, outside USB, ignore that approach anyway and work 2.5
style.)
-- 
Stefan Richter
-=====-==-== -=== --===
http://arcgraph.de/sr/

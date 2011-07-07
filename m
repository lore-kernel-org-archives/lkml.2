Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1GGUmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:42:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:27291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1GGUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,495,1304319600"; 
   d="scan'208";a="24624765"
Date: Thu, 7 Jul 2011 13:42:03 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0-rc6: USB khubd deadlock when hub is powered down
Message-ID: <20110707204203.GA13931@xanatos>
References: <20110707100501.68a21fb8@stein>
 <20110707152958.42c88aec@stein>
 <20110707153849.51691bc4@stein>
 <20110707141022.GC27648@kroah.com>
 <20110707212449.261ffa78@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707212449.261ffa78@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:24:49PM +0200, Stefan Richter wrote:
> On Jul 07 Greg KH wrote:
> > Can you test Linus's tree, along with a patch sent yesterday from Alan
> > Stern to the linux-usb mailing list (attached below)?  That should
> > resolve this issue, if not, please let us know.
> 
> OK.  I am using 3.0-rc6-71-g4dd1b49 plus Alan's "USB: additional
> regression fix for device removal" now.  So far it survived a dozen of
> power toggles of the hub and the attached devices.  Thanks.
> 
> Alan Stern wrote:
> > Still, we need to rewrite this stuff.  A possible race remains,
> 
> On a general level, the last few kernel.org releases have all been rather
> weak.  Dissatisfied,

For USB regressions or the kernel overall?  Yes, last kernel release had
some nasty regressions-disguised-as-bug-fixes in the USB tree as well.
My fault there, not sure how to improve other than coming up with a list
of every possible plug-unplug/reset/configure/alt setting change
combination possible and testing before sending any thing at all.
Suggestions welcome, testing appreciated.

Sarah Sharp

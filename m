Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033357Ab2I1VrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:47:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:3087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030711Ab2I1VrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,504,1344236400"; 
   d="scan'208";a="215728500"
Date: Fri, 28 Sep 2012 14:47:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Gabor Takacs <gbrtakacs@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: PROBLEM: kernel 3.6.rc6 bug report (usb 3.0 external hard drive
 problem)
Message-ID: <20120928214709.GA7260@xanatos>
References: <20120928141639.GH5368@mwanda>
 <Pine.LNX.4.44L0.1209281026470.1518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1209281026470.1518-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:27:43AM -0400, Alan Stern wrote:
> On Fri, 28 Sep 2012, Dan Carpenter wrote:
> 
> > I've filed a bug for this.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=48061
> > 
> > Probably the other information which would be useful is the output
> > from lsusb.  Anyway, I've added the USB list to the CC.
> > 
> > regards,
> > dan carpenter
> > 
> > On Sun, Sep 23, 2012 at 05:33:44PM +0200, Gabor Takacs wrote:
> > > Bug report for kernel version 3.6.rc6
> > > 
> > > Content of message:
> > > 
> > > - One-line description
> > > - Full description
> > > - Keywords
> > > - CPU info
> > > - Modules info
> > > - Kernel version
> > > - Loaded driver and hardware information
> > > - PCI information
> > > - SCSI information
> > > 
> > > One-line description: Western Digital My Passport USB 3.0 hard drive not
> > > handled by kernel
> > > 
> > > Full description: under 3.6.rc6 kernel on an Asus Zenbook Prime UX21A,
> > > when plugging in my
> > > Western Digital My Passport USB 3.0 hard drive, the system does not
> > > mount it. It worked with
> > > previous (3.4.x) kernels.
> 
> If this failure is reliable then git bisection would be a good way to 
> pin down the source of the problem.

This looks awfully like Don Zickus' issue with his WD hard drive:

http://marc.info/?l=linux-usb&m=134886294107752&w=2

But LPM was added in 3.4, so I don't know why 3.4.x kernels worked.
Gabor, does the patch in that mail fix your issue with the WD drive?

Sarah Sharp

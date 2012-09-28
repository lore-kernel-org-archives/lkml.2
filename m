Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2I1O1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:27:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932117Ab2I1O1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:27:44 -0400
Date: Fri, 28 Sep 2012 10:27:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Gabor Takacs <gbrtakacs@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: kernel 3.6.rc6 bug report (usb 3.0 external hard drive
 problem)
In-Reply-To: <20120928141639.GH5368@mwanda>
Message-ID: <Pine.LNX.4.44L0.1209281026470.1518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Dan Carpenter wrote:

> I've filed a bug for this.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=48061
> 
> Probably the other information which would be useful is the output
> from lsusb.  Anyway, I've added the USB list to the CC.
> 
> regards,
> dan carpenter
> 
> On Sun, Sep 23, 2012 at 05:33:44PM +0200, Gabor Takacs wrote:
> > Bug report for kernel version 3.6.rc6
> > 
> > Content of message:
> > 
> > - One-line description
> > - Full description
> > - Keywords
> > - CPU info
> > - Modules info
> > - Kernel version
> > - Loaded driver and hardware information
> > - PCI information
> > - SCSI information
> > 
> > One-line description: Western Digital My Passport USB 3.0 hard drive not
> > handled by kernel
> > 
> > Full description: under 3.6.rc6 kernel on an Asus Zenbook Prime UX21A,
> > when plugging in my
> > Western Digital My Passport USB 3.0 hard drive, the system does not
> > mount it. It worked with
> > previous (3.4.x) kernels.

If this failure is reliable then git bisection would be a good way to 
pin down the source of the problem.

Alan Stern


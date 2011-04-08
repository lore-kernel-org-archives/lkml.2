Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1DHQaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:30:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752739Ab1DHQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:30:14 -0400
Date: Fri, 8 Apr 2011 12:30:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v4] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <20110408150955.GD23633@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104081229370.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Roedel, Joerg wrote:

> > > +	info = amd_chipset;
> > 
> > What's the point of this line?  You're just going to write over all the 
> > data in info anyway, so it doesn't matter what amd_chipset contains.  A 
> > memset would work just as well.
> 
> info is on-stack and needs to be initialized somehow because the
> following code does not touch the whole data structure.

Then just use memset.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2BTQvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:51:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38414 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab2BTQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:51:02 -0500
X-Sasl-enc: 7FZ5wIdPwCCPNsTlxtxeZdkjXgmAL8hdJuydqRq2p0/W 1329756659
Date: Mon, 20 Feb 2012 08:44:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile warnings,
 linux-3.2.6a/arch/x86/include/asm/uaccess_32.h, was Re: Linux 3.2.6
Message-ID: <20120220164450.GA19580@kroah.com>
References: <20120213192545.GA28291@kroah.com>
 <h561k71mg76rebd4m46l25791ilkcr8n0r@4ax.com>
 <20120219152108.GB15136@kroah.com>
 <5nt3k7hnqp0cpctcalotfordt752jvqp3c@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5nt3k7hnqp0cpctcalotfordt752jvqp3c@4ax.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 06:32:30PM +1100, Grant Coady wrote:
> On Sun, 19 Feb 2012 07:21:08 -0800, you wrote:
> 
> >On Sun, Feb 19, 2012 at 05:50:45PM +1100, Grant Coady wrote:
> >> On Mon, 13 Feb 2012 11:25:45 -0800, you wrote:
> >> 
> >> >I'm announcing the release of the 3.2.6 kernel.
> >> >
> >> >All users of the 3.2 kernel series must upgrade.
> >> 
> >> I'm getting:
> >> ...
> >>   CC      drivers/net/Space.o
> >
> ><snip>
> >
> >Does this also happen in 3.2.5?  Can you narrow it down to a specific
> >patch?
> 
> Yes, and all the way back to 3.2.  No idea what brought it on, 3.2.6 
> was a skip from 2.6.38.7 for me so I cannot easily tell when it came in.

Then please contact the netdev mailing list with this issue, as it's a
"mainline" issue, not stable-release-specific.

thanks,

greg k-h

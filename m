Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2CUU7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:59:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39478 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab2CUU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:59:10 -0400
X-Sasl-enc: MXZ0hqilH4L0+9EvStV6DKwL/6SYICXpduiucBbkvIyA 1332363549
Date: Wed, 21 Mar 2012 13:59:08 -0700
From: Greg KH <greg@kroah.com>
To: Mate Soos <mate@srlabs.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Kernel Oops when unplugging USB
Message-ID: <20120321205908.GA8456@kroah.com>
References: <4F6747FF.1060005@srlabs.de>
 <20120320135637.GA4634@kroah.com>
 <4F6A3155.30603@srlabs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6A3155.30603@srlabs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:51:49PM +0100, Mate Soos wrote:
> Dear Greg,
> 
> On 03/20/2012 02:56 PM, Greg KH wrote:
> > On Mon, Mar 19, 2012 at 03:51:43PM +0100, Mate Soos wrote:
> >> [2.] Full description of the problem/report:
> >> The kernel oops-ed when I pulled out an umounted 8GB USB key. This seems
> >> to be visible in the "messages" file. All the data attached, except for
> >> the "messages" has been produced after a reboot, since the system
> >> hanged. Luckily, the "messages" got saved. The system after restart
> >> should have exactly the same modules loaded as before.
> >>
> >> [3.] Keywords (i.e., modules, networking, kernel):
> >> USB, Kernel Ooops, Watchdog
> >>
> >> [4.] Kernel version (from /proc/version):
> >> $ cat
> >>  /proc/version
> >> Linux version 3.2.0-1-amd64 (Debian 3.2.4-1) (waldi@debian.org) (gcc
> >> version 4.6.2 (Debian 4.6.2-12) ) #1 SMP Sun Feb 5 15:17:15 UTC 2012
> > 
> > Can you please try the 3.2.12 release, this should be resolved there
> > already.
> > 
> > Or can you try 3.3?
> 
> Can you please indicate what you are suspecting to have fixed the
> problem? Once verified, I could add it to the bugzilla entries at

Look at the patches from 3.2.0 to 3.2.12, a number of them might have
fixed this, previous reporters say that this problem is now gone, hence
me asking if this is true here as well.

thanks,

greg k-h

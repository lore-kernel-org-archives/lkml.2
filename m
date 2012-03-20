Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab2CTN4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:56:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51573 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760019Ab2CTN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:56:39 -0400
X-Sasl-enc: XuG0hOAj5d/4iiigQByxxanUIb6aoRlhbbVrGFwtmCXi 1332251798
Date: Tue, 20 Mar 2012 06:56:37 -0700
From: Greg KH <greg@kroah.com>
To: Mate Soos <mate@srlabs.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Kernel Oops when unplugging USB
Message-ID: <20120320135637.GA4634@kroah.com>
References: <4F6747FF.1060005@srlabs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6747FF.1060005@srlabs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:51:43PM +0100, Mate Soos wrote:
> Hi,
> 
> I had a kernel oops, so I thought I might report it.
> 
> [1.] One line summary of the problem
> See 'messages' for the actual kernel oops messages.
> 
> [2.] Full description of the problem/report:
> The kernel oops-ed when I pulled out an umounted 8GB USB key. This seems
> to be visible in the "messages" file. All the data attached, except for
> the "messages" has been produced after a reboot, since the system
> hanged. Luckily, the "messages" got saved. The system after restart
> should have exactly the same modules loaded as before.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> USB, Kernel Ooops, Watchdog
> 
> [4.] Kernel version (from /proc/version):
> $ cat
>  /proc/version
> Linux version 3.2.0-1-amd64 (Debian 3.2.4-1) (waldi@debian.org) (gcc
> version 4.6.2 (Debian 4.6.2-12) ) #1 SMP Sun Feb 5 15:17:15 UTC 2012

Can you please try the 3.2.12 release, this should be resolved there
already.

Or can you try 3.3?

thanks,

greg k-h

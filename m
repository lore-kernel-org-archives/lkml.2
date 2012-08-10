Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab2HJRxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:53:34 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:24542 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2HJRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:53:32 -0400
Date: Fri, 10 Aug 2012 19:53:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, ap@solarrain.com
Subject: Re: Upgraded from 3.4 to 3.5.1 kernel: machine does not boot
In-Reply-To: <0bac01cd7717$9fa6bbf0$def433d0$@lucidpixels.com>
Message-ID: <alpine.LNX.2.00.1208101948590.17673@swampdragon.chaosbits.net>
References: <0bac01cd7717$9fa6bbf0$def433d0$@lucidpixels.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Justin Piszcz wrote:

> Hello,
> 
> Motherboard: Supermicro X8DTH-6F
> Distro: Debian Testing x86_64
> 
> >From 3.4 -> 3.5.1 on x86_64 make oldconfig and a few minor changes and the
> machine attempts to boot but hangs at the filesystem mounting part of the
> boot process.
> 
> Picture of where it stops working (a little burry but readable)
> http://home.comcast.net/~jpiszcz/20120810/3.5-kernel-hangs.jpg
> 
> Kernel config 3.4 (working)
> http://home.comcast.net/~jpiszcz/20120810/config-3.4.txt
> 
> Kernel config 3.5.1 (hangs)
> http://home.comcast.net/~jpiszcz/20120810/config-3.5.1.txt
> 
> As you see towards the end the machine has been sitting there for 1 hour as
> that's the timeout I have the drives spindown on the 3ware card.
> 
> Any thoughts as what is wrong here?
> 
Not really, but some (rather obvious) ideas on what to try:

- Does 3.5 work? (could be that whatever broke things for you was 
introduced in 3.5.1).

- Does the latest 3.4.8 work?

- Does 3.6-rc1 (or even the latest snapshot of Linus' tree, post-rc1) 
work?

- If noone comes up with a good idea as to the cause of your troubles, you 
could try bisecting between your last working kernel and 3.5.1 to try and 
narrow it down to one (or a few) commits that are causing your trouble.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


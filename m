Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab0EMRAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:00:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab0EMRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:00:38 -0400
Date: Thu, 13 May 2010 09:58:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005130955240.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Linus Torvalds wrote:
> 
> PnP information _commonly_ doesn't inclure PS/2 ports, even when they 
> exist. Lack of PnP information about the keyboard port means absolutely 
> nothing, and anybody who tells you otherwise is totally and utterly wrong. 
> 
> So don't confuse this with PnP issues. That's a total red herring, and 
> Apple is _not_at_all_ "doing the proper thing in the BIOS". 

Btw, was this an EFI boot?

I could easily see bootcamp working (it's been tested with Windows, after 
all), but not EFI (I've heard rumors of Windows booting from EFI, but I 
don't know if those are actually correct). 

And I'd be a _lot_ more open to saying "if you booted from EFI, then we're 
going to ignore any legacy devices that aren't in PnP tables".

In fact, we effectively do that today by having different code-paths for 
ia64 (which was EFI) and x86 (which is obviously traditionally not EFI).

			Linus

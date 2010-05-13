Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab0EMQi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:38:29 -0400
Received: from xenotime.net ([72.52.115.56]:49806 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759306Ab0EMQi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:38:26 -0400
Date: Thu, 13 May 2010 09:38:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-Id: <20100513093820.dca1f423.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.2.00.1005130908350.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
	<1273762051.2308.4671.camel@localhost.localdomain>
	<alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
	<20100513155031.GA22238@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130908350.3711@i5.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 09:16:31 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > 
> > From what I remember (it was a few weeks old thread) we were hanging
> > when trying to read from the controller in i8042_flush(). Normally, if
> > controller isn't there we'd get a stream of 0xff which will never
> > "clear" and so after 32 reads we give up and abort controller
> > initialization. But on Bastien's box it just sits there.
> 
> Is there a web interface to some archive for linux-input (or was this 
> thread on lkml)?

>From Jan. 20, on lkml.
See http://lkml.org/lkml/2010/1/20/254


> Anyway, the fact that apparently pressing the power button makes it come 
> alive again implies that it's likely SCI/SMI-related. Which is not 
> entirely unexpected if there is some crazy SMM thing going on. But 
> presumably whatever buggy Apple code is _supposed_ to work for Windows, so 
> I wonder what bug that quite simple status/data register read could 
> possibly trigger.
> 
> Is it the status read or the data read that causes problems, and is it the 
> first one or after doing a few? A couple of printk's in that i8042_flush() 
> routine should tell us.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

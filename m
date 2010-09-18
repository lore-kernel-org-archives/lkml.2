Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0IRTsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:48:03 -0400
Received: from xenotime.net ([72.52.115.56]:47096 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757590Ab0IRTry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:47:54 -0400
Date: Sat, 18 Sep 2010 12:47:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Joshua Hintze" <joshh@imsar.com>
Cc: "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: PATA IDE is slower in newer versions of kernel
Message-Id: <20100918124750.393a64a8.rdunlap@xenotime.net>
In-Reply-To: <010d01cb5769$cbca3380$635e9a80$@com>
References: <00d401cb55f7$33a78210$9af68630$@com>
	<20100917154732.330c4b1b@varda>
	<010901cb5754$ae6735a0$0b35a0e0$@com>
	<1284837774.12425.1.camel@localhost.localdomain>
	<010d01cb5769$cbca3380$635e9a80$@com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010 13:43:40 -0600 Joshua Hintze wrote:

> Thanks,
> 
> I'm not sure what you mean by bisect, other than just the definition of the word. I am breaking this problem down adding printks etc.  I think I'm finally beginng to understand how this works :)
> 

http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#using-bisect


> 
> 
> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org [mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Maxim Levitsky
> Sent: Saturday, September 18, 2010 1:23 PM
> To: Joshua Hintze
> Cc: linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
> Subject: RE: PATA IDE is slower in newer versions of kernel
> 
> On Sat, 2010-09-18 at 11:12 -0600, Joshua Hintze wrote:
> > Some updated information. I created a screen capture of what I am seeing. First is the logic analyzer when the newer linux kernel is writing slow to the PATA port.
> > 
> > http://i56.tinypic.com/oqhrug.png
> > 
> > Notice in the above link how there is a lot of activating and then large gaps of no activity. After about 9 mS the STOP line is strobed a few times and then DMARQ finally returns to normal operating. The link below shows the picture of an old 2.6.10 kernel where write speeds are much faster.
> > 
> > http://i51.tinypic.com/a9wiur.png
> > 
> > In the above image notice how the wait time is considerable less 100's of microseconds before the stop lines get strobed.
> > 
> > I'm dedicated to continue working on the problem, I just need to advice from the linux community. I've tried different I/O schedulers such as noop and anticipatory and I'm studying the ide-dma code but still lost to where this is happening.
> > 
> > Thanks!
> > 
> Maybe you can just bisect this?
> Just a general advice, I don't know ide subsystem at all.
> 
> Best regards,
> 	Maxim Levitsky


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

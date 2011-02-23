Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1BWDVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:21:24 -0500
Received: from relais.videotron.ca ([24.201.245.36]:62588 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1BWDVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:21:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 22 Feb 2011 22:21:21 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Dima Zavin <dima@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
In-reply-to: <8ya8vx7jvqh.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1102222209350.22028@xanadu.home>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
 <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
 <4D5DC289.1090004@codeaurora.org>
 <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
 <1298419839.17118.5.camel@m0nster> <8ya62sbli3z.fsf@huya.qualcomm.com>
 <alpine.LFD.2.00.1102222049410.22028@xanadu.home>
 <8ya8vx7jvqh.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, David Brown wrote:

> On Tue, Feb 22 2011, Nicolas Pitre wrote:
> 
> > And if someone else comes up with a SSBI interface, then it will be much 
> > easier to notice the already existing driver if it is in the driver 
> > directory rather than somewhere else in some unrelated (from that 
> > person's pov) obscure directory.
> 
> Well, I'm fairly sure that nobody would be making an SSBI interface, but
> point taken.

It's not necessarily the SSBI interface per se that is interesting to 
other people, but rather the fact that the code driving it might be 
relying upon generic kernel infrastructure, such as driver or bus 
registration, interrupt requests, resource allocation, etc.

> So what kinds of things constitute drivers versus arch-specific code?
> Currently, iommu drivers seem to be sprinkled throughout arch.

Yes, and so are clock source and clock event "drivers".  Some things 
fall into a gray area and this is not always clear what the proper 
location is for them.  But as a rule of thumb you should follow what 
most other people did, and if there is no example to follow then just go 
with drivers/msm/ by default which should be a pretty safe bet.


Nicolas

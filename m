Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1BWDGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:06:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45831 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1BWDGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:06:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6265"; a="75876286"
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Daniel Walker <dwalker@fifo99.com>, Dima Zavin <dima@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	<1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	<4D5DC289.1090004@codeaurora.org>
	<1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
	<1298419839.17118.5.camel@m0nster> <8ya62sbli3z.fsf@huya.qualcomm.com>
	<alpine.LFD.2.00.1102222049410.22028@xanadu.home>
X-Hashcash: 1:20:110223:bryanh@codeaurora.org::K1KAso7tZaxOWpCz:000000000000000000000000000000000000000007n2
X-Hashcash: 1:20:110223:pavel@ucw.cz::y19RmuxahCcoznQf:000002TPL
X-Hashcash: 1:20:110223:dima@android.com::+ftcYgrcpARixWiX:02y30
X-Hashcash: 1:20:110223:linux-arm-kernel@lists.infradead.org::2rpKa0hJ3BUNacOa:000000000000000000000000027v+
X-Hashcash: 1:20:110223:linux-kernel@vger.kernel.org::7pJXeAF+HKf5QGWv:0000000000000000000000000000000006hc8
X-Hashcash: 1:20:110223:tsoni@codeaurora.org::K2aUEgs1vPxeLhnb:000000000000000000000000000000000000000002v50
X-Hashcash: 1:20:110223:kheitke@codeaurora.org::o6z3tpmNoSfaW+p7:0000000000000000000000000000000000000004Kzu
X-Hashcash: 1:20:110223:dwalker@fifo99.com::OCnp/faM5ePCahx1:00000000000000000000000000000000000000000004Qvo
X-Hashcash: 1:20:110223:nico@fluxnic.net::H8HHorZfdgg20HT7:07lBR
X-Hashcash: 1:20:110223:linux-arm-msm@vger.kernel.org::O/PkNJ9owsyI34Yr:00000000000000000000000000000000DS8m
Date: Tue, 22 Feb 2011 19:05:58 -0800
In-Reply-To: <alpine.LFD.2.00.1102222049410.22028@xanadu.home> (Nicolas
	Pitre's message of "Tue, 22 Feb 2011 21:37:28 -0500 (EST)")
Message-ID: <8ya8vx7jvqh.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22 2011, Nicolas Pitre wrote:

> And if someone else comes up with a SSBI interface, then it will be much 
> easier to notice the already existing driver if it is in the driver 
> directory rather than somewhere else in some unrelated (from that 
> person's pov) obscure directory.

Well, I'm fairly sure that nobody would be making an SSBI interface, but
point taken.

>> It seems kind of unusual to create an entirely new directory under
>> drivers to hold what will only ever be a single driver.
>
> Well, a couple examples exist already: drivers/dca, drivers/nfc, 
> drivers/sn, drivers/tc, drivers/vlynq, etc.  And if you expect to have 
> more oddball msm drivers then you can create a drivers/msm directory, 
> similar to the existing drivers/macintosh, drivers/parisc, drivers/s390, 
> drivers/sh, drivers/video/omap, drivers/video/omap2, etc.

drivers/msm seems like a reasonable place.  We already have other
drivers that are in appropriate places.

So what kinds of things constitute drivers versus arch-specific code?
Currently, iommu drivers seem to be sprinkled throughout arch.

We also have a shared-memory driver-type thing that is only used by
other drivers.  Does that make sense to be in drivers/msm?

Ken, do you mind moving this driver into 'drivers/msm' as the first one
there?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

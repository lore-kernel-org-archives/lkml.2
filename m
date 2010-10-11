Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0JKUNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:13:41 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:39508 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0JKUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:13:40 -0400
Subject: RE: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
From: Jon Masters <jonathan@jonmasters.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Jon Masters <jcm@jonmasters.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE1381EE4B69@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20101008065810.GA1680@constitution.bos.jonmasters.org>
	 <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE1381EE4B69@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 11 Oct 2010 16:12:06 -0400
Message-ID: <1286827927.24745.7.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 10:45 -0700, Brett Rudley wrote:
> Thanks for the input.

No problem. I'd like to fix this as much as you would, since the STA
driver isn't an option here. Just for kicks, I tried STA after this but
it didn't work with the wireless extensions on my system and I much
prefer getting the staging driver fixed. Meanwhile, I have no WiFi on my
shiny new netbook, so I'm very keen to help get this fixed :)

> The 4313 (Device ID 4327) is pretty solid on the 32 bit staging-next
> kernel (loads, runs for days, no issues, etc).

Can you do me three favors:

1). Tell me what kind of hardware you are testing on that's 32-bit?
2). How many CPUs (threads, cores, whatever) do you have?
3). Share your test kernel configuration?

It's likely that we could have a combination of different config (I have
every debug option turned on pretty much) and different word size and
I'd love to have that data. I will look through the crash tonight.

> On the other hand, I haven't been using anything other than that kernel
> recently so its  very, very likely there are problems with other kernels,
> especially 64 bit which I haven't even attempted yet (but will of course).

We need data points on 64-bit kernels. Anyone else care you share?

> Please do try out the 32 bit staging-next kernel and let me know how
> it goes.

Sorry. I don't have a suitable test environment with this hardware (it
took several hours to get to the disk and swap it out the other night
since ASUS really don't want me to do that) but I suppose I might try a
nightly rawhide 32-bit compose on a USB stick and built the driver
against that - hmm. That might be a nice way to test 32-bit.

> Yeah, turning on msglevel produces more (and possibly *much* more)
> output.  

Yea. What about the high order bits in the phy msglevel, what are they
intended to be doing? Could you, perhaps, give us some more useful docs
to accompany what is in the staging tree at this point?

Thanks,

Jon.



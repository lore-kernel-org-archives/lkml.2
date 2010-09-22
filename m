Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0IVH3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 03:29:52 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27757 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0IVH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:29:51 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L950O9-02-KFO-02
X-M-MSG: 
Date: Wed, 22 Sep 2010 09:26:33 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Arnd Bergmann <arnd@arndb.de>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Message-ID: <20100922072633.GV13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
 <201009211321.06172.arnd@arndb.de>
 <20100921141329.GU13563@erda.amd.com>
 <38667ac18ee6604649af9396cf156182.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <38667ac18ee6604649af9396cf156182.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.10 10:38:04, Andi Kleen wrote:
> > On 21.09.10 07:21:05, Arnd Bergmann wrote:
> >> Just curious about the other missing IDs: this now supports all Core
> >> microarchitecture CPUs, but only some Nehalem/Westmere ones.
> >>
> >> There is support for 0x1a (Bloomfield/Gainestown) and 0x2e (Beckton),
> >> but
> >> not for the much more common 0x1e (Lynnfield/Clarksfield/Jasper Forest),
> >> 0x25 (Clarkdale/Arrandale) and 0x26 (Gulftown/Westmere-EP).

I also found reports for 0x2c (Gulftown/Westmere-EP?):

vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz

-Robert

> >>
> >> Shouldn't those be added as well?
> 
> Westmere I still hold off because the oprofile user land
> doesn't have the correct event list yet.
> 
> BTW I was thinking in this case to only add the model
> numbers to the user code and just let it handle arch_perfmon
> from the kernel.
> 
> This should work currently fine and avoid the problem
> that you need to update user land and kernel in parallel
> for a new cpu type.
> 
> >>
> >> When you're there, it probably also wouldn't hurt to fill in the blanks
> >> of some of the older CPUs like Tolopai (0x15) and newer Atoms (0x1c).
> >
> > Yes, would be nice to have also an update for the remaining
> > unsupported models. Andi?
> 
> Yes would make sense. I'll ask around if there is a consolidated
> list somewhere that could be used as a base.
> 
> -Andi
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


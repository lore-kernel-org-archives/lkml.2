Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0HaMbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:31:10 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:40936 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0HaMbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:31:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C7CF725.50503@jic23.retrosnub.co.uk>
Date: Tue, 31 Aug 2010 13:35:49 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>	<20100829184904.GC26209@core.coreip.homeip.net>	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>	<20100830214025.2f9677a1@lxorguk.ukuu.org.uk>	<20100830204412.GA28711@core.coreip.homeip.net>	<AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>	<20100830214355.GB28865@core.coreip.homeip.net>	<AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>	<20100830224352.GF28865@core.coreip.homeip.net> <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
In-Reply-To: <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/10 10:44, Alan Cox wrote:
>> 1. Input transport via evdev is very convenient
>> 2. There is no other standard alternative
>>
>> Once there is standard interface for such sensors they will happily use
>> it and will not look back.
> 
> I think the fact that most of the interest in IIO is "how do we make an
> IIO/Input bridge" speaks volumes.
It isn't.  Most of the interest on LKML might be, but that is because all
of those interested in the 'industrial' side of things are keeping
their discussion on linux-iio@vger list.  Most of the noise on LKML may
be on the input bridge side, but most of the actual work and current
developers / users are not.  The needs we have are not all met by input,
(and nor should they be) hence the reason IIO exists.

Take a look at the work Analog have been doing with it. There are
few devices in their set that would fall into the blurred area we are
debating here. 3 phase energy meters for input anyone?
> 
>> Sure, for a particular cell phone there is no ambiguity, the sensor has
>> certain functionality assigned that is well known. But does this mean
>> that we should not expect parts being reused at all anymore?
> 
> If non-input uses later need non-input interfaces they can switch to that
> with an input bridge when there is one and when it happens, which
> probably won't.
I guess I'll just have to write the bridge :)  To put in userspace
code for a particular device should be trivial.  It may take a little
more time and thought to get a configurable general version in place.

It may not be the right option for some devices, but it will provide
a means if someone wants to take one of Analog's rather nice IMU's
or a 200G accelerometer and use it to drive their gaming rig ;)
Also, there are always devices using analog sensors connected to
much more general purpose ADCs to further blur the boundaries.
There has to be divide somewhere. Dmitry is merely trying to avoid
a flood of inappropriate drivers.
> 
>> I am unsure how you would play a game with GPS as an input device.
> 
> In a non-game context take a look at things like the British Museum
> application that allows you to view wherever you are and as it was long
> ago by fishing out a relevant photograph as you walk around. In a game
> context can I suggest the Zombies game is an example ?
> 
> Alan

Jonathan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1LHQXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:23:31 -0500
Received: from host171.canaca.com ([67.55.55.225]:47925 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1LHQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:23:29 -0500
Message-ID: <80063840e8a9778675e9a63db6f1d956.squirrel@host171.canaca.com>
In-Reply-To: <CANq1E4T6uoezonoaBk6agD4-6A7QMSiP0ySDPg+5r50G8LYWTA@mail.gmail.com>
References: <4EDFD23D.4030703@xenotime.net>
    <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
    <b92a2d1d30910b75f3354926d9fa26f6.squirrel@host171.canaca.com>
    <CANq1E4T6uoezonoaBk6agD4-6A7QMSiP0ySDPg+5r50G8LYWTA@mail.gmail.com>
Date: Thu, 8 Dec 2011 11:23:26 -0500
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
From: simon@mungewell.org
To: "David Herrmann" <dh.herrmann@googlemail.com>
Cc: simon@mungewell.org, linux-input@vger.kernel.org, rdunlap@xenotime.net,
        linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I don't mean to be a complainer, but shouldn't the WiiMote module depend
>> on FF_MEMLESS rather than just forcing it on.
>
> I have considered that but "grep -r FF_MEMLESS" returned no other
> driver using "depend" so I decided to use "select", too.

If you look at 'Kconfig' every other driver is fragmented into a 'driver'
and 'driver_ff', it is only the 'driver_ff' bit which does the
force-feedback and all the 'drivers' would appear to work OK (as pure
input devices) with FF disabled.

Someone here will be able to comment whether that is policy, convention or
just historic....

>> Some people might not want FF_MEMLESS enabled.
>
> Why? It is a really small feature that depends only on CONFIG_INPUT.
> Just 600 lines of code. I don't see why someone who wants to enable
> the way bigger wiimote driver and HID core would bother about
> FF_MEMLESS? Why should someone want to disable the rumble-feature of
> the wiimote?

600 lines where? What's the other costs to the system when enabling the FF
code in the kernel.

> I cannot see any real use-case here. Maybe you can explain a bit more.

Again I'm not here to kick up a fuss; it just looked different from the
norm, so I was flagging it.

Simon


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0H3UuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:50:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0H3UuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nEjSxAEyi7WzZT1X/idOTBuJublE8blp8D6Rcg/8Hz6fPKR6UofQNKmjhFfxH+N50x
         gSvStcAc+7yyX5aVEOwcvmahQTcslaq2vLaewfQVOKBi2Z+X9gMasVXLtbW9GXcQRo7W
         jVEtL3CYoqrewEI3nXruURrtwiuzBJX51GFiQ=
Date: Mon, 30 Aug 2010 13:50:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Hemanth V <hemanthv@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        igor.stoppa@nokia.com, kai.svahn@nokia.com, mathias.nyman@nokia.com
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
Message-ID: <20100830205011.GB28711@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830162855.GA17325@core.coreip.homeip.net>
 <d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com>
 <20100830172143.GA28275@core.coreip.homeip.net>
 <3fe11bc61e6a844b926ec4d32cec1474@secure211.sgcpanel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe11bc61e6a844b926ec4d32cec1474@secure211.sgcpanel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 01:52:18PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Mon, 30 Aug 2010 10:21:44 -0700, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > My response to this - are gyroscopes will _only_ be used to turn around
> > in a game? Are proximity sensor is _only_ usable as a trigger in FPS?
> > Won't we ever see such chips controlling technological processes?
> 
> similarly, will accelerometers always be used as input devices ?
> of course not, they have been used e.g. to spin down hard disks
> on laptops when they are shaken too hard. Still they have quite a
> fair bit of usage as input devices; you've seen it yourself,
> right ?
> 

This is a fair point. I was told that the main purpose for the chips in
question (specifically 3-axis accelerometers) is to be used as HIDs.
But it could be that I should not have merged adxl and instead waited
for IIO.

> in the end of the day, when you put those on mobile devices
> like e.g. cellphones, app developers will be really keen on
> creating new ways for interacting with apps (be it a game
> or not) using those devices, so I will agree with Jonathan
> that, maybe, having two separate drivers for different
> purposes would make sense, although that might cause a bit
> of trouble if user ends up enabling the wrong driver when
> building custom kernel for his device.

No, I do not believe that maintaining 2 separate devices for the same
hardware with the only difference is how data is presented to userspace
is a viable option.

> 
> My hope is that we can make use of a well known and uniform
> API for all input devices in a device, be it a keypad,
> touchscreen, accelerometer, magnetometer, gyro, or whatever.
> 

If only we could agree what input devices are...

-- 
Dmitry

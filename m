Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0H3SwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:52:18 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:39890 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0H3SwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:52:16 -0400
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 13:52:18 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hemanth V <hemanthv@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <igor.stoppa@nokia.com>, <kai.svahn@nokia.com>,
        <mathias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
In-Reply-To: <20100830172143.GA28275@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com> <20100830162855.GA17325@core.coreip.homeip.net> <d6b6aa8195784d6baf3ffcdc365c6361@secure211.sgcpanel.com> <20100830172143.GA28275@core.coreip.homeip.net>
Message-ID: <3fe11bc61e6a844b926ec4d32cec1474@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 30 Aug 2010 10:21:44 -0700, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> My response to this - are gyroscopes will _only_ be used to turn around
> in a game? Are proximity sensor is _only_ usable as a trigger in FPS?
> Won't we ever see such chips controlling technological processes?

similarly, will accelerometers always be used as input devices ?
of course not, they have been used e.g. to spin down hard disks
on laptops when they are shaken too hard. Still they have quite a
fair bit of usage as input devices; you've seen it yourself,
right ?

in the end of the day, when you put those on mobile devices
like e.g. cellphones, app developers will be really keen on
creating new ways for interacting with apps (be it a game
or not) using those devices, so I will agree with Jonathan
that, maybe, having two separate drivers for different
purposes would make sense, although that might cause a bit
of trouble if user ends up enabling the wrong driver when
building custom kernel for his device.

My hope is that we can make use of a well known and uniform
API for all input devices in a device, be it a keypad,
touchscreen, accelerometer, magnetometer, gyro, or whatever.

-- 
balbi

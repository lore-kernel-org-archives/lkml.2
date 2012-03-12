Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2CLSTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:19:30 -0400
Received: from host171.canaca.com ([67.55.55.225]:42753 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2CLST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:19:28 -0400
Message-ID: <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>
In-Reply-To: <20120312180738.GD14020@sirena.org.uk>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
    <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
    <20120312180738.GD14020@sirena.org.uk>
Date: Mon, 12 Mar 2012 14:19:25 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
From: simon@mungewell.org
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: simon@mungewell.org, "Jiri Kosina" <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
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

> On Mon, Mar 12, 2012 at 02:04:14PM -0400, simon@mungewell.org wrote:
>
>> At the moment you'd just drive the LEDs simply, ie:
>> $ echo 31 > /sys/bus/hid/devices/.../leds
>
> Shouldn't this be using the LED subsystem the kernel already has?
>

The LED subsystem appears to be aim at controller chips (ie. lp3944) which
are connected to a bus (I2C) in a generalised form. I guess people might
be doing 'blinken light' type systems.

The LEDs on the G27 are very much more specific, mounted on the yoke of
the gaming wheel.

Would this require the use/complexity of the LED subsystem?
Simon



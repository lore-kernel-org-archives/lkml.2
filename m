Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2CPRfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:35:37 -0400
Received: from host171.canaca.com ([67.55.55.225]:53165 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2CPRff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:35:35 -0400
Message-ID: <683cca338c740abdd522a35dfe3b17a9.squirrel@mungewell.org>
In-Reply-To: <20323.28731.474538.955921@quad.stoffel.home>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
    <20323.25792.171143.809563@quad.stoffel.home>
    <f04eb1355e17dbe4ce7bbdd47da0056e.squirrel@mungewell.org>
    <20323.28731.474538.955921@quad.stoffel.home>
Date: Fri, 16 Mar 2012 13:35:33 -0400
Subject: Re: Building BarGraph with LED subsystem
From: simon@mungewell.org
To: "John Stoffel" <john@stoffel.org>
Cc: simon@mungewell.org, "John Stoffel" <john@stoffel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
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


>>> While making the kernel more complex... esp for a feature which is of
>>> such limited use.
>
> simon> Is the concept of a bargraph of LEDs really a 'limited use'? I
> simon> can think of several uses... I mean isn't flashing or a heart
> simon> beat just as limited ;-)
>
> Yes, it's a limited use.  Are 10% of linux users going to have this
> hardware and use it?

OK I'm not making myself clear, apologies for that.

I'd be proposing a 'ledtrig-thres' module which is totally independent of
the G27, which would just provide the ability to light (or dark) a LED
depending on a threshold and value.

With a bit of extra code (in this module) multiple LEDs could be 'linked'
to produce a bargraph, by automatically comparing the same value against
their own thresholds.

As to the hardware; it could be the G27, a single LED or a matrix of LEDs
slung off one of the other LED subsystem devices.

I'd want to show RPMs on my G27, but others could display CPU usage,
emulate a VU meter/FFT display, have the 'low memory panic light' come on,
etc...


> simon> Once kernel framework is provided it should not need
> simon> re-compilation on a case by case basis.
>
> If the kernel only provides a way to set the brightness of individual
> LEDs, why can't you do the rest in userspace?  What if the user wants
> to have the LEDs run right to left, or visa versa?

I'm just wondering whether writing this as a trigger module is of use to
others. If well defined, lots of uses are possible.

Simon


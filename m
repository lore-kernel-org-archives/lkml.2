Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2CLTFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:05:44 -0400
Received: from host171.canaca.com ([67.55.55.225]:57791 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab2CLTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:05:42 -0400
Message-ID: <03eaca06ba2629f55144daa5a386c74b.squirrel@mungewell.org>
In-Reply-To: <20120312183235.GA28451@opensource.wolfsonmicro.com>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
    <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
    <20120312180738.GD14020@sirena.org.uk>
    <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>
    <20120312183235.GA28451@opensource.wolfsonmicro.com>
Date: Mon, 12 Mar 2012 15:05:39 -0400
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


>> The LEDs on the G27 are very much more specific, mounted on the yoke of
>> the gaming wheel.
>
>> Would this require the use/complexity of the LED subsystem?
>
> Well, it'd mean that applications that know how to drive LEDs will be
> able to use the LEDs on this wheel with less per device knowledge which
> seems like a useful thing and if someone wants to remap a LED to "new
> mail" or whatever that'll be easier (nethack has the mailer daemon
> deliver a scroll of mail!).

I'm not familiar with the LED subsystem, but my concerns would be that
this would add a whole load of code to implement.

Most of concern is the fact that the Logitech wheels are transitioned from
a 'simple' wheel when they are plugged in to an 'advanced' wheel, they
release/re-register with a different USB ID.

The port (for a lack of a better word) for controlling the LEDs is mixed
in with the FF and wheel configuration commands. All this is handled
within the hid-lg4ff driver (if FF is not enabled you just get the
'simple' wheel behaviour).

If you can point me at some (simple) implementations of the LED subsystem,
possibly with some guidance, we can look to see if the added complexity is
actually worth it.

I'd be pretty sure that other gaming controllers don't abstract their LEDs
via this subsystem,
Simon.

PS. I don't really care about email when screaming around Laguna Seca ;-)



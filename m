Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1DGXEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:04:10 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35035 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1DGXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:04:08 -0400
Message-ID: <4D9E42E1.1060902@ahsoftware.de>
Date: Fri, 08 Apr 2011 01:04:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on	the
 basis of the memory size.
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home> <4D9CED15.2010806@ahsoftware.de> <alpine.LFD.2.00.1104061850410.28032@xanadu.home> <4D9CF5B3.9020007@ahsoftware.de> <toa078-0do.ln1@chipmunk.wormnet.eu> <4D9E2D1C.7070102@ahsoftware.de> <20110407220855.GD17049@n2100.arm.linux.org.uk>
In-Reply-To: <20110407220855.GD17049@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.04.2011 00:08, schrieb Russell King - ARM Linux:

>> Requiring a machine ID and the needed stuff to handle that for a board
>> which just is using two GPIOs different than another board is why the
>> ARM tree exploded.
>
> You can not be any more wrong than that.
>
> The reason the ARM tree exploded is because of the compartmentalized
> sub-community structure, where the vast majority of (eg) OMAP development
> is done independently of the (eg) Samsung development.
>
> Consequently, there's no attempt to consolidate code between the SoCs,
> even for basic stuff like 32-bit up-counting timers.  We've ended up with
> _nine_ implementations of clocksources all doing the same thing in that
> respect.
>
> That's got precisely zilch to do with machine IDs, and your attempt to
> blame the bloat on machine IDs just shows how misinformed you are.

I had a look at what's going on in the OMAP linux world for more than a 
year now and I think I've seen a lot of the stuff you are referring to.

And I think one of the reasons that the mess happened is the same I've 
got trapped in. Why should anyone try to submit patches if he must fear 
to get caught in some senseless endless discussion about one line.

E.g. requiring people to use NULL than 0 or that stupid discussion now 
about the simple patch I've posted. I'm writing whole (readable) C++ 
applications (not crap!) in less time than what's is needed to submit 
and discuss a small patch for some silly hw.

So for me it's fully understandable why companies don't try to work with 
kernel people at first. They try to develop innovativ products they can 
sell, and it doesn't help if their developers would have to fear that 
they get called stupid, crap and abonimation writing aliens for things 
like the small patch I've posted, which in turn requires them to defend 
them against those people doing so (which ends in such stupid 
discussions like this).

It's one thing to say such to someone you know and work with, but it's a 
totally different thing to say such to someone you almost know nothing 
about. And not everybody who hasn't the name of a big company in his 
email address is a moron.

Sorry, I'm getting sick having to defend me here against people who like 
to call others crap and abonimation writing ones just because they have 
maintainer status or whatever.

Regards,

Alexander

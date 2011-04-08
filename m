Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab1DHHo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:44:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39486 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab1DHHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:44:55 -0400
Date: Fri, 8 Apr 2011 08:24:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
	basis of the memory size.
Message-ID: <20110408072420.GA27450@n2100.arm.linux.org.uk>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home> <4D9CED15.2010806@ahsoftware.de> <alpine.LFD.2.00.1104061850410.28032@xanadu.home> <4D9CF5B3.9020007@ahsoftware.de> <toa078-0do.ln1@chipmunk.wormnet.eu> <4D9E2D1C.7070102@ahsoftware.de> <20110407220855.GD17049@n2100.arm.linux.org.uk> <4D9E42E1.1060902@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9E42E1.1060902@ahsoftware.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 01:04:01AM +0200, Alexander Holler wrote:
> Am 08.04.2011 00:08, schrieb Russell King - ARM Linux:
>
>>> Requiring a machine ID and the needed stuff to handle that for a board
>>> which just is using two GPIOs different than another board is why the
>>> ARM tree exploded.
>>
>> You can not be any more wrong than that.
>>
>> The reason the ARM tree exploded is because of the compartmentalized
>> sub-community structure, where the vast majority of (eg) OMAP development
>> is done independently of the (eg) Samsung development.
>>
>> Consequently, there's no attempt to consolidate code between the SoCs,
>> even for basic stuff like 32-bit up-counting timers.  We've ended up with
>> _nine_ implementations of clocksources all doing the same thing in that
>> respect.
>>
>> That's got precisely zilch to do with machine IDs, and your attempt to
>> blame the bloat on machine IDs just shows how misinformed you are.
>
> I had a look at what's going on in the OMAP linux world for more than a  
> year now and I think I've seen a lot of the stuff you are referring to.
>
> And I think one of the reasons that the mess happened is the same I've  
> got trapped in. Why should anyone try to submit patches if he must fear  
> to get caught in some senseless endless discussion about one line.

Because matching against the memory size is _technically_ the wrong thing
to do, as you've already been told.

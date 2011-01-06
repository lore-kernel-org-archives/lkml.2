Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1AFSjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:39:07 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60044 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab1AFSjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:39:05 -0500
From: Kevin Hilman <khilman@ti.com>
To: Nishanth Menon <nm@ti.com>
Cc: Koen Kooi <koen@dominion.thruhere.net>, Brad Parker <brad@heeltoe.com>,
        Anand Gadiyar <gadiyar@ti.com>, Ming Lei <tom.leiming@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Organization: Texas Instruments, Inc.
References: <20101223171859.f6842045.sfr@canb.auug.org.au>
	<4D139517.3010608@ti.com>
	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>
	<4D25E313.4060202@heeltoe.com>
	<8B3471BB-CB3F-4CE6-B523-D9C5E87B9CEC@dominion.thruhere.net>
	<87pqs9vqya.fsf@ti.com> <4D260812.3010605@ti.com>
Date: Thu, 06 Jan 2011 10:38:59 -0800
In-Reply-To: <4D260812.3010605@ti.com> (Nishanth Menon's message of "Thu, 06
	Jan 2011 12:21:06 -0600")
Message-ID: <871v4pvpvg.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> Kevin Hilman had written, on 01/06/2011 12:15 PM, the following:
>> Koen Kooi <koen@dominion.thruhere.net> writes:
>>
>>> Op 6 jan 2011, om 16:43 heeft Brad Parker het volgende geschreven:
>>>
>>>> It's probably expected, but I can't get the EHCI USB port  to work
>>>> on a beagle board XM (36xx) using the current omap tree.
>>>>
>>>> It this most likely due to these clock issues?
>>> You need this patch: http://thread.gmane.org/gmane.linux.ports.arm.omap/47807/
>>>
>>> I'm currently too lazy to split it up like Nishant wants as I don't
>>> see the point splitting for the sake of splitting.--
>>
>> IMO, it doesn't need to be split up.
>>
>> But it does have to fix the other comments I made on the same thread[1]
>>
>> 1) add a descriptive changelog, and
>> 2) Cc linux-arm-kernel
>
> Kevin,
> there are four things being done in the patch:
> a) fix GPIO number for EHCI power on
> b) fix GPIO number for DVI reset line
> c) switch on DVI
> d) switch on Camera
>
> I have split the first 2 up. I just splitting the (c) up when I
> noticed the code is confusing - I will reply in thread to the original
> patch.
>
> I apologize, but I disagree - as far as I see it, these are separate
> changes being done.

Sure, but there are all tiny and isolated.  For me, what's missing is
just a changlog describing all the changes.

Feel free to break it up if you prefer, but IMO it would be mergable as
a single patch if there was a descriptive changelog actually mentioning 
all the changes made (as you just did above.)

Kevin

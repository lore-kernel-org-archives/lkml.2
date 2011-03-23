Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1CWKmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:42:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45781 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1CWKmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=K6B2UKD66QxbHvJUQSWj9wkyvbgDSU7UnjRBamyehQkeB2ADSWAA7DXZxcxG32ea3X
         L4ygSWAFT+QSp+6WuxcNBeIDZ/BdzUxzf0btjpqadopf0KnZWekQKiR9xKMP1LRXKY4j
         3+klxG2/WpYcnqJMrkmtSBSiGON5Qge8OB0mk=
Message-ID: <4D89CDE4.3000504@linaro.org>
Date: Wed, 23 Mar 2011 10:39:32 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk> <4D89C618.1020608@linaro.org> <201103231132.02690.arnd@arndb.de>
In-Reply-To: <201103231132.02690.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 10:32 AM, Somebody in the thread at some point said:
> On Wednesday 23 March 2011, Andy Green wrote:
>> It's the case for even usbnet, which is using a broken heuristic to
>> decide what to call the interface not even based on vid / pid.
>
> I agree that the heuristics in usbnet is less than helpful here,
> which among other things leads people to mixing up the two problems
> of fixing the device naming and fixing the MAC address assignment.
>
> Even though I know Greg disagrees, I'd still prefer sanitising the
> rules for the default device name that usbnet assigns. Simply letting
> a device driver flag "this is always an external ethernet, not
> a point-to-point connection" would be enough to solve this problem,
> and take some of the heat out of the discussion for how to solve
> the MAC address assignment.

Completely agree, I have a happy feeling being able to say that too. 
But I already see there's no path through Greg let alone Alan, so it'll 
have to be dealt with a less good way.

>> Before this RFC there's no generic support for the concept, although
>> that hasn't stopped it being implemented in wl12xx already at individual
>> mainline driver level.  And before this RFC, I don't believe there was
>> any concept of async tagging through bus path for soldered-on assets in
>> Device Tree either.
>
> For the device tree, the method has always been to assign the device_node
> pointer to the device when the parent bus gets probed, that has not changed.
> The new idea that came as a result of your RFC is to use the same mechanism
> that we use elsewhere for USB as well, with the existing USB binding.

Fair enough.

-Andy



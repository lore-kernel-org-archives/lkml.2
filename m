Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1DGJoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:44:10 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51671 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1DGJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:44:09 -0400
Message-ID: <4D9D8762.3080207@ahsoftware.de>
Date: Thu, 07 Apr 2011 11:44:02 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nico Erfurth <ne@erfurth.eu>
CC: Eric Cooper <ecc@cmu.edu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and Seagate
 DockStars
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <4D9CEE24.1080501@erfurth.eu> <4D9D81ED.7090809@ahsoftware.de> <4D9D85E4.2040606@erfurth.eu>
In-Reply-To: <4D9D85E4.2040606@erfurth.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.04.2011 11:37, schrieb Nico Erfurth:
> Alexander Holler wrote:
>
>> I wonder how many people believe that either there will be another
>> DockStar with the same HW and GPIOs for the LEDs but more memory (and
>> still without sata) or that there will be another SheevaPlug with just
>> 128MB RAM or that someone could have a reason to change the memory
>> layout using a mem= parameter.
>>
>> For me all that is pretty unlikely.
>
> As Nicolas stated it's not just about "Oh, thats totally unlikely to
> happen!". It is about maintainable code, if somebody looks at it in 3
> years they should not think "WTF?!?!". Using machine ids and the
> generated macros helps to keep the code clean and readable.

Sorry, I can't agree. For me some unique hardware identifier is more 
reasonable, than some machine id which comes from outerspace.

And in no way I see any argument for that "clean and readable", at least 
not in the patch I posted.

Anyway, I leave this discussion and wish all a nice day.

Regards,

Alexander

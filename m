Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1FMXFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:05:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37059 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1FMXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uPpOCz2Fuw/CzX+2uiN1MiXEDpTQi6gIqfD5Fsm8VgnvC+GJmoMqfkQNFATrd9Wkr5
         yFAJlq8D1OXTg9LHoVCN3V1jqy5RmbNHmNO5Wkap6FZlPq6XW+ltbs4r1jJpa3JyIYc2
         oD4GpyJVnV5ZqsB7PjHkBVhK7y18IBEtDeM0Y=
Message-ID: <4DF697B4.6080000@gmail.com>
Date: Tue, 14 Jun 2011 09:05:24 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org,
        jj@chaosbits.net
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address across
 the kernel
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>	<20110610025532.GE26006@linux-sh.org> <20110610095641.664fad35@lxorguk.ukuu.org.uk>
In-Reply-To: <20110610095641.664fad35@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 18:56, Alan Cox wrote:
> On Fri, 10 Jun 2011 11:55:49 +0900
> Paul Mundt<lethal@linux-sh.org>  wrote:
>
>> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
>>> I no longer work at Bluewater Systems. Update my email address accordingly.
>>>
>> Is this sort of churn really necessary?
> Yes - stale email addresses cause all sorts of problems, particularly if
> in the future the address is re-used in the company. It also causes
> confusion over who owns and maintains stuff because it's never obvious
> whether the resolution of an unknown address is
>
> A.	'user has moved on, follow the user'
>
> B.	'user has moved on, company probably has someone else assigned
> 	 to it'

Okay, so there seem to be a number of different opinions on this. I 
would really like some solution for this so it can go into 3.0. The 
options I see are:

a) My original patch
b) My original patch, but delete email address in .[ch] files rather 
than change it
c) Entry in .mailmap (will this work for 3.0?)
d) Add MAINTAINERS entries for each of the files which have my email 
address in them
e) Some combination of the above

Is there a preferred option? Who (Linus?) do I need to Cc to get this 
included for 3.0?

Thanks,
~Ryan


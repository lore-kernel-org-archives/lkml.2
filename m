Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0KZHhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:37:05 -0500
Received: from rs35.luxsci.com ([66.216.127.90]:35295 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KZHhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:37:01 -0500
Message-ID: <4CEF6373.60105@firmworks.com>
Date: Thu, 25 Nov 2010 21:36:19 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Grant Likely <grant.likely@secretlab.ca>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Scian <andrea.scian@dave.eu>
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
References: <1290607413.12457.44.camel@concordia>	 <1290692075.689.20.camel@concordia>	 <AANLkTiknyKi1pzvUP2WnasudZwH27-a0FxCX0BSHBdQp@mail.gmail.com>	 <1290741341.9453.377.camel@concordia>  <4CEF3AB1.9060200@firmworks.com> <1290750606.9453.394.camel@concordia>
In-Reply-To: <1290750606.9453.394.camel@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> One Laptop Per Child ships real Open Firmware on its x86 Linux systems,
>> of which approximately 2 million have been shipped or ordered.  An ARM
>> version, also with OFW, is in the works.
>
> OK. I don't see any code under arch/x86 or arch/arm that uses of_()
> routines though? Or is it under drivers or something?
>

Andres Salomon has been working for some time to get some Open Firmware 
support for x86 upstream.  As you can probably imagine, it has been slow 
going, but seems to be getting close.

The OLPC ARM work is just beginning, so nothing has been submitted yet. 
  The first hardware prototypes are still being debugged. Lennert 
Buytenhek is the key OS person who will be involved.

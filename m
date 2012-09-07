Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2IGGsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:48:10 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40404 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2IGGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:48:08 -0400
Message-ID: <504998A2.6000705@gmail.com>
Date: Fri, 07 Sep 2012 16:48:02 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ep93xx: Fix build error due to 'SZ_32M' undeclared
References: <1346675368.15950.0.camel@phoenix> <5049346B.5020205@gmail.com> <CAF+7xWko4wokuU-OiMYq3a2RJyaSb=qXM+LOpJCKHYpEB1Xi2Q@mail.gmail.com>
In-Reply-To: <CAF+7xWko4wokuU-OiMYq3a2RJyaSb=qXM+LOpJCKHYpEB1Xi2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/12 15:48, Axel Lin wrote:
>> Hi Axel,
>>
>> The patch looks fine. I notice that the other ep93xx boards are also
>> using the SZ_ defines, but are indirectly including linux/sizes.h via
>> asm/memory.h, which in turn is indirectly included via asm/io.h. That
> Seems this is also true for other platforms ( e.g. mach-pxa, mach-ux500, etc)
> 
>> seems a bit flaky, so I wonder if we should just explicitly include
>> <linux/sizes.h> in all the board files which use the SZ_ macros as per
>> the patch below. Thoughts?
> I'm 50/50 on this.
> But if we do these changes, this patch is more than a build fix.

Fair enough,

I've applied your patch as-is to my ep93xx-fixes branch.

Thanks,
~Ryan



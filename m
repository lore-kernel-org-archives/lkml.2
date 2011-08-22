Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1HVOvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:51:13 -0400
Received: from mail0.scram.de ([78.47.204.202]:55562 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1HVOvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:51:12 -0400
Authentication-Results: localhost; dkim=hardfail (verification failed)
	header.i=@scram.de; dkim-asp=unknown
X-Spam-Flag: NO
X-Spam-Score: -4.44
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
Message-ID: <4E526CAA.7070108@scram.de>
Date: Mon, 22 Aug 2011 16:50:18 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Bryan Wu <bryan.wu@canonical.com>, kristoffer.ericson@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.2 0/4] ARM: simpad: Add support for GPIO attached	hardware
References: <1312793379-6020-1-git-send-email-jochen@scram.de> <4E43F44A.1000509@scram.de> <CAK5ve-J7ARjDDm2OzrBiBBd9VrMjdDdihiRcPFwK4xm+_gwMrg@mail.gmail.com> <20110818102526.GB21865@n2100.arm.linux.org.uk>
In-Reply-To: <20110818102526.GB21865@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.08.2011 12:25, Russell King - ARM Linux wrote:
> On Thu, Aug 18, 2011 at 05:05:49PM +0800, Bryan Wu wrote:
>> On Thu, Aug 11, 2011 at 11:24 PM, Jochen Friedrich<jochen@scram.de>  wrote:
>>> On 08.08.2011 10:49, Jochen Friedrich wrote:
>>>
>>>> This series enables GPIO API on UCB1x00 and implements the GPIO
>>>> API on the CS3 latch. The third patch finally registers platform
>>>> devices for the GPIO attached LED, buttons and I2C bus.
>>>>
>>>> ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
>>>> ARM: simpad: Cleanup CS3 accessors and add GPIO API
>>>> ARM: simpad: add GPIO based device definitions
>>>> ARM: simpad: replace ARM specific LED code
>>>
>>> ping.
>>>
>>> Did someone have time to look at this yet?
>>>
>> Russell,
>>
>> Is there any comment, or Jochen can just submit them into patch system
>
> I don't think so, and yes.

Done. 7027/1, 7024/1, 7025/1 and 7026/1.

Thanks,
Jochen

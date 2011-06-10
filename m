Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1FJAu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:50:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FJAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mq+ehxT0apyESSvLLCDjKs2X0v9pIrzRNFYw6jeDzG5sFkU7zEFNnWA1Aj/UKUk4A7
         e5hyGnSUIjcvtnfFoSfBMCkT0UWjK+5VbFJhC+5rvRjLynzLI4fGfgIIYm39+vtfdjev
         0IIFqLKtuzg8eIj+Dw2zlAiCggROZ/jfDYAbQ=
Message-ID: <4DF16A4B.5010905@gmail.com>
Date: Fri, 10 Jun 2011 10:50:19 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andre Renaud <andre@bluewatersys.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Paul Mundt <lethal@linux-sh.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address across
 the kernel
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com> <ADE657CA350FB648AAC2C43247A983F001F3820B86BF@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B86BF@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 10:28, H Hartley Sweeten wrote:
> On Thursday, June 09, 2011 4:13 PM, Ryan Mallon wrote:
>> I no longer work at Bluewater Systems. Update my email address accordingly.
>>
>> Signed-off-by: Ryan Mallon<rmallon@gmail.com>
>> Cc: Andre Renaud<andre@bluewatersys.com>
>> Cc: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Nicolas Ferre<nicolas.ferre@atmel.com>
>> Cc: Andrew Victor<avictor.za@gmail.com>
>> Cc: David Woodhouse<dwmw2@infradead.org>
>> Cc: Anton Vorontsov<cbou@mail.ru>
>> Cc: Paul Mundt<lethal@linux-sh.org>
>> Cc: Liam Girdwood<lrg@ti.com>
>> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
>> Cc: trivial@kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
> Acked-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>
> Ryan,
>
> There will probable be some merge conflicts with this.

They should be trivial to fix (or automatic). I would also like this to 
get merged into 3.0 if still possible. Otherwise I'm going to get three 
more months of people emailing me at the wrong address :-).

~Ryan

>> MAINTAINERS                            |    2 +-
>> arch/arm/mach-at91/board-snapper9260.c |    2 +-
>> arch/arm/mach-ep93xx/dma-m2p.c         |    2 +-
> This file is gone after Mika's DMA patches which are already in linux-next.
>
>> arch/arm/mach-ep93xx/gpio.c            |    2 +-
> This file has been moved and renamed.  There are also a number of patches
> already applied to it in linux-next.
>
>> arch/arm/mach-ep93xx/simone.c          |    4 ++--
>> arch/arm/mach-ep93xx/snappercl15.c     |    4 ++--
>> drivers/mtd/devices/sst25l.c           |    4 ++--
> There are a couple patches to this file in linux-next.
>
>> drivers/power/ds2782_battery.c         |    4 ++--
>> drivers/video/ep93xx-fb.c              |    2 +-
>> sound/soc/ep93xx/ep93xx-i2s.c          |    4 ++--
>> sound/soc/ep93xx/ep93xx-pcm.c          |    4 ++--
>> sound/soc/ep93xx/snappercl15.c         |    4 ++--
> The others should be ok.  Maybe you should rebase this patch against
> linux-next?
>
> Regards,
> Hartley


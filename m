Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0EZQRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:17:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61442 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab0EZQRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mI3W9f6BxVH3QzKk82LHPLeUDQ1FxGgtvT0QLcYOJGcutH/qYuKoAqQsCBUr08VBrY
         rkUGa/HNC1sHbZ2S2buXxt5LaMMGkYovcIfS3uDdhInYDoO2DgkH9SuVXx2K5kJf2JD+
         HxN5IaZf+0mxzdXG5CAo0wh97cPeckMsnJZH8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
	 <AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
Date: Wed, 26 May 2010 09:17:42 -0700
X-Google-Sender-Auth: 4sc5RgSURKQEdWL88Hd3okMmYVo
Message-ID: <AANLkTikiW_yFOqRumd83sETURf-9sI7IfrCmbb5MRjrl@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 4:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, May 20, 2010 at 12:49 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> This completes the DMA40 support with the platform-specific
>> configuration for U8500/DB8500.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
>> Reviewed-by: Alessandro Rubini <rubini@unipv.it>
>> Cc: STEricsson_nomadik_linux@list.st.com
>> ---
>> Dan, now that Russells depending patches from the ARM tree have
>> been merged to Linus' (Torvalds) tree, do you think it's possible
>> to also push this DMA40 platform data through the async_tx tree?
>> This is the final version of it.
>> ---
>>  arch/arm/mach-ux500/clock.c                    |    2 +-
>>  arch/arm/mach-ux500/cpu-db8500.c               |    4 +
>>  arch/arm/mach-ux500/devices-db8500.c           |  219 ++++++++++++++++++++++++
>>  arch/arm/mach-ux500/include/mach/db8500-regs.h |   12 ++
>>  arch/arm/mach-ux500/include/mach/devices.h     |    3 +
>>  arch/arm/mach-ux500/ste-dma40-db8500.h         |  154 +++++++++++++++++
>>  6 files changed, 393 insertions(+), 1 deletions(-)
>>  create mode 100644 arch/arm/mach-ux500/ste-dma40-db8500.h
>>
>
> Russell, I will be sending one more pull request for this merge window
> and plan to include this with your acked-by.  It finishes off the
> support for the dma40 driver.
>

Ping?

Requesting acked-by for:

http://marc.info/?l=linux-kernel&m=127434177015990&w=2

Thanks,
Dan

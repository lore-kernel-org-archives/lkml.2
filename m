Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2K2UfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:35:19 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62826 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2K2UfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:35:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121120161638.GD28265@gmail.com>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
	<1352973847-21605-2-git-send-email-lee.jones@linaro.org>
	<CAH9JG2UX0Wyr-QKw3=tbUXeuEhHe04_cFkkAp6bB2Rr-x7ViHQ@mail.gmail.com>
	<20121115112543.GC21682@gmail.com>
	<20121120161638.GD28265@gmail.com>
Date: Thu, 29 Nov 2012 12:35:16 -0800
X-Google-Sender-Auth: Z-iSnipiR5HvdTBdqVYzgCtk__w
Message-ID: <CAPnjgZ1SRvZtUD7wUV4E41Vi7q6B9qGLvGPhMqx_Heoq7YwOkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
From: Simon Glass <sjg@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Kyungmin Park <kmpark@infradead.org>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, jonas.aberg@stericsson.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 20, 2012 at 8:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > > +/* for automatic boot timing testcases */
>> > > +#define ATAG_BOOTTIME  0x41000403
>> > Where can I refer this ATAG usage? can you point out the reference URL
>> > or patches?
>>
>> I assumed this would be in Mainline u-boot, but apparently not.
>> On closer inspection of the internal ST-Ericsson u-boot, this
>> functionality appears to be provided by patches which currently
>> exist as delta. So in essence, the bootloader you use will have
>> to be patched in a similar way for you to retrieve information
>> surrounding bootloader boot times.
>>
>> And there was me thinking it was magic. ;)
>
> Okay, so I'm going through the motions of upstreaming this magic
> now. Please see the link below for reference:
>
> http://marc.info/?l=u-boot&m=135342273317337&w=2

Given that U-Boot has bootstage, would it make sense to upstream that
to the kernel? Some RFC patches were sent before this went into U-Boot
to sound out the interest.

http://lwn.net/Articles/460432/

Regards,
Simon

>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

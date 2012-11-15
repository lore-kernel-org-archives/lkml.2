Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423660Ab2KOLZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:25:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34874 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:25:49 -0500
Date: Thu, 15 Nov 2012 11:25:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linus.walleij@stericsson.com,
        jonas.aberg@stericsson.com, will.deacon@arm.com, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH 1/2] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121115112543.GC21682@gmail.com>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
 <1352973847-21605-2-git-send-email-lee.jones@linaro.org>
 <CAH9JG2UX0Wyr-QKw3=tbUXeuEhHe04_cFkkAp6bB2Rr-x7ViHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH9JG2UX0Wyr-QKw3=tbUXeuEhHe04_cFkkAp6bB2Rr-x7ViHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* for automatic boot timing testcases */
> > +#define ATAG_BOOTTIME  0x41000403
> Where can I refer this ATAG usage? can you point out the reference URL
> or patches?

I assumed this would be in Mainline u-boot, but apparently not.
On closer inspection of the internal ST-Ericsson u-boot, this
functionality appears to be provided by patches which currently
exist as delta. So in essence, the bootloader you use will have
to be patched in a similar way for you to retrieve information
surrounding bootloader boot times.

And there was me thinking it was magic. ;)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2K3IVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:21:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54454 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2K3IVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:21:44 -0500
Date: Fri, 30 Nov 2012 08:21:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Simon Glass <sjg@chromium.org>
Cc: Kyungmin Park <kmpark@infradead.org>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, jonas.aberg@stericsson.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121130082139.GA26023@gmail.com>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
 <1352973847-21605-2-git-send-email-lee.jones@linaro.org>
 <CAH9JG2UX0Wyr-QKw3=tbUXeuEhHe04_cFkkAp6bB2Rr-x7ViHQ@mail.gmail.com>
 <20121115112543.GC21682@gmail.com>
 <20121120161638.GD28265@gmail.com>
 <CAPnjgZ1SRvZtUD7wUV4E41Vi7q6B9qGLvGPhMqx_Heoq7YwOkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnjgZ1SRvZtUD7wUV4E41Vi7q6B9qGLvGPhMqx_Heoq7YwOkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012, Simon Glass wrote:

> Hi,
> 
> On Tue, Nov 20, 2012 at 8:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> > > +/* for automatic boot timing testcases */
> >> > > +#define ATAG_BOOTTIME  0x41000403
> >> > Where can I refer this ATAG usage? can you point out the reference URL
> >> > or patches?
> >>
> >> I assumed this would be in Mainline u-boot, but apparently not.
> >> On closer inspection of the internal ST-Ericsson u-boot, this
> >> functionality appears to be provided by patches which currently
> >> exist as delta. So in essence, the bootloader you use will have
> >> to be patched in a similar way for you to retrieve information
> >> surrounding bootloader boot times.
> >>
> >> And there was me thinking it was magic. ;)
> >
> > Okay, so I'm going through the motions of upstreaming this magic
> > now. Please see the link below for reference:
> >
> > http://marc.info/?l=u-boot&m=135342273317337&w=2
> 
> Given that U-Boot has bootstage, would it make sense to upstream that
> to the kernel? Some RFC patches were sent before this went into U-Boot
> to sound out the interest.

Right. As Simon and I have already discussed, I am pulling the
u-boot and kernel boottime components in lieu of bootstage.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

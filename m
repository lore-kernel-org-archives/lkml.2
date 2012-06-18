Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2FRLgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:36:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36565 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZSkQM-RCWvjRxWrU5VT0RN6eh9i4QXg-YUMn7KvtW3OQ@mail.gmail.com>
References: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
	<CACRpkda6FJm4fiQ9w0Mo80_B7W09yCwMdMeqoiDUtkifJ88_RQ@mail.gmail.com>
	<CAHdPZaNs87D+x6WUiMMmOtTdLWJoxrUN-FawuVN1F=oKi3Q=ow@mail.gmail.com>
	<CACRpkdZSkQM-RCWvjRxWrU5VT0RN6eh9i4QXg-YUMn7KvtW3OQ@mail.gmail.com>
Date: Mon, 18 Jun 2012 17:06:10 +0530
Message-ID: <CAHdPZaOgSzJbnqSz2BKB-T+u-8s5Vy_FOgsJ46UBL57-8_goHw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mxs: Use kfree to fix build error
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jun 18, 2012 at 11:57 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Mon, Jun 18, 2012 at 8:15 AM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>
>> The pinctrl is not selectable even with make allyesconfig. is it for a
>> different arch than x86?
>
> At the request of Linus (Torvalds) machines and drivers that need pinctrl
> shall select it explicitly in the Kconfig, and it's hidden for all others so
> as not to confuse people and present them with strange stuff.
>
> So currently only some ARM machines that actually use it will select it and
> enable the sub-menu. But there is also a MIPS patch in the works.

Thanks for letting me know about the pinctrl build configuration.
>
>> may i know which cross compiler to use to build the pinctrl subsystem :) ?
>
> I use the prebuilt Linaro GCC toolchain:
> https://launchpad.net/linaro-toolchain-binaries/+download
>
> Put the /bin subdir in your path and e.g.:
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- mxs_defconfig
> etc
>
Thanks! i set up the cross toolchain now. :)

>From now onwards you can expect at least compile tested patches from me.

> Linus Walleij

Thanks,
Devendra.

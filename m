Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030184Ab2GCC2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:28:40 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:46294 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab2GCC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaNSqiUg2Vq_CXYGX9wa1E_rJKFT3POL-_Yqu1SEYvLoyA@mail.gmail.com>
References: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
 <CAK5ve-JaNGoWuCTP5ddMEEfpA3ucWNL_ayj5ULU3+++5a02pWw@mail.gmail.com>
 <CAHdPZaNDW+XCrf9Mse-N3jtgtrrx9Z0+W1YZX8nPETa7ZZFB1w@mail.gmail.com> <CAHdPZaNSqiUg2Vq_CXYGX9wa1E_rJKFT3POL-_Yqu1SEYvLoyA@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 3 Jul 2012 10:28:17 +0800
X-Google-Sender-Auth: N5OF8ieV-esYyNVjVwVhZCvA_2I
Message-ID: <CAK5ve-KnVcXgw0W7-wRrnrCrpu0d9dSkRckGHx=y6p4vdi8i0w@mail.gmail.com>
Subject: Re: [PATCH] leds-mc13783: set platform data to NULL at mc13783_led_remove
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 2:10 AM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> Hi Bryan,
>
> I Made all the necessary changes, and it touched 21 drivers overall,
> and i compile tested all except leds-sunfire as i dont have a
> cross-toolchain for that.
> all patches are compile tested with
>
> gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3, ( my machine's)
> arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.05-20120523 -
> Linaro GCC 2012.05) 4.7.1 20120514 (prerelease) (ARM toolchain's)
>
> at each cross-compile of a driver i selected the defconfig of each
> machine, fox ex. for leds-netxbig i chose kirkwood-defconfig, and for
> leds-s3c24xx i chose s3c2410_defconfig.
>

Very good, thanks a lot.

> Now i have only 1 question in mind :).
>
> do i need to submit all in a single patch? or patch per driver?
>

I prefer to one patch per driver and please add the driver maintainers
in you Cc list of each patch.

-Bryan
